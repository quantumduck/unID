class ProvidersController < ApplicationController
  # before_action :require_login

  SETTINGS = {
    'google' => {
      auth_uri: 'https://accounts.google.com/o/oauth2/v2/auth',
      base_uri: 'https://www.googleapis.com',
      scopes: ['/auth/userinfo.profile', '/auth/plus.me'],
      callback: 'http://localhost:3000/auth/google/callback',
      params: {'prompt' => 'consent', 'response_type' => 'code', 'access_type' => 'offline'},
      token_path: '/oauth2/v4/token',
      token_headers: {'content-type' => 'application/x-www-form-urlencoded'},
      client_id: ENV['google_client_id'],
      client_secret: ENV['google_client_id_secret'],
      id_query: '/plus/v1/people/me?fields=displayName%2Cid%2Cimage%2Cname',
      profile_prefix: 'https://plus.google.com/u/'
    },
    'youtube' => {
      auth_uri: 'https://accounts.google.com/o/oauth2/v2/auth',
      base_uri: 'https://www.googleapis.com',
      scopes: ['/auth/youtube.readonly'],
      callback: 'http://localhost:3000/auth/youtube/callback',
      params: {'prompt' => 'consent', 'response_type' => 'code', 'access_type' => 'offline'},
      token_path: '/oauth2/v4/token',
      token_headers: {'content-type' => 'application/x-www-form-urlencoded'},
      client_id: ENV['google_client_id'],
      client_secret: ENV['google_client_id_secret'],
      id_query: '/youtube/v3/channels?part=id%2CbrandingSettings&mine=true',
      profile_prefix: 'https://www.youtube.com/channel/'
    },
    'twitter' => {

    }
  }

  def authorize
    # This route is only used for providers without an oauth2 gem.
    settings = SETTINGS[params[:provider]]
    scopes = settings[:scopes].map { |s| CGI.escape(settings[:base_uri] + s) }
    scopes = scopes.join('+')
    query = '?redirect_uri='
    query += CGI.escape(settings[:callback]) + '&'
    settings[:params].each { |k, v| query += k + '=' + v + '&'}
    query += 'scope=' + scopes + '&'
    query += 'client_id=' + ENV['google_client_id']
    response = HTTParty.get(settings[:auth_uri] + query)
    render html: response.body.html_safe
  end

  def callback
    provider = params[:provider]
    if provider == 'youtube' || provider == 'google'
      get_token(provider)
    else
      oauth_params = get_params(provider)
      if current_user
        # If user is signed in, create a new profile.
        create_profile(oauth_params)
      end
      else
        login_or_create(oauth_params)
      end
    end
  end

  def login_or_create(user_params)
    profile = Profile.where(provider: provider, uid: uid).first
    if profile
      user = profile.user
      session[:user_id] = user.id
      redirect_to "/#{user.username}", notice: "Logged in via #{provider.capitalize}!"
    else
      user = create_user(user_params)
    end
  end

  def create_profile(profile_params)
    if Profile.where(provider: provider, uid: uid).first
      # refresh profile or token
    else
      profile = Profile.new(oauth_params)
      profile.user_id = current_user.id
      if profile.save
        flash[:success] = "successful oauth get request"
        redirect_to "/#{current_user.username}"
      else
        # This error message should be improved at some point
        @auth = env('omniauth.auth')
        render :oauth_error
      end
    end
  end

  def get_token(provider)
    settings = SETTINGS[params[:provider]]
    uri = settings[:base_uri] + settings[:token_path]
    body = 'code=' + CGI.escape(params[:code]) + \
      '&client_id=' + settings[:client_id] + \
      '&client_secret=' + settings[:client_secret] + \
      '&redirect_uri=' + CGI.escape(settings[:callback]) + \
      '&scope=&grant_type=authorization_code'
    token_response = HTTParty.post(uri, body: body, headers: settings[:token_headers])
    token_info = token_response.parsed_response
    profile = Profile.new
    if token_response.code == 200
      profile.token = token_info['access_token']
      profile.expires_at = Time.now + token_info['expires_in']
      profile.expires = true
      profile.refresh_token = token_info['refresh_token']
      profile.user_id = current_user.id
      profile.provider = params[:provider]
      call_id_api(profile)
    else
      render plain: "ERROR: no token\n\n#{token_response.inspect}"
    end
  end

  def call_id_api(profile)
    settings = SETTINGS[profile.provider]
    uri = settings[:base_uri] + settings[:id_query]
    headers = {
      'Authorization' => 'Bearer ' + profile.token
    }
    api_response = HTTParty.get(uri, headers: headers)
    if api_response.code == 200
      case profile.provider
      when 'youtube'
        if api_response.parsed_response['items'].size >= 1
          channel = api_response.parsed_response['items'][0]
          profile.uid = channel['id']
          profile.url = settings[:profile_prefix] + profile.uid
          profile.name = channel['brandingSettings']['channel']['title']
          profile.image = channel['brandingSettings']['image']['bannerImageUrl']
          if profile.save
            redirect_to "/#{current_user.username}"
          else
            render plain: "ERROR: profile save\n\n#{profile.inspect}"
          end
        else
          render plain: "ERROR: no id\n\n#{api_response.inspect}"
        end

      when 'google'
        profile.uid = api_response.parsed_response['id']
        profile.url = settings[:profile_prefix] + profile.uid
        profile.name = api_response.parsed_response['displayName']
        profile.first_name = api_response.parsed_response['givenName']
        profile.last_name = api_response.parsed_response['familyName']
        profile.image = api_response.parsed_response['image']['url']
        if profile.save
          redirect_to "/#{current_user.username}"
        else
          render plain: "ERROR: profile save\n\n#{profile.inspect}"
        end
      end
    else
      render plain: "ERROR: #{api_response.code}\n\n#{api_response.inspect}"
    end
  end

private

def get_params(provider)
  auth = env['omniauth.auth'].to_hash
  new_params = {uid: auth['uid'], provider: auth['provider']}
  case provider
  when 'twitter'
    new_params[:name] = auth['info']['name'],
    new_params[:nickname] = auth['info']['nickname'],
    new_params[:image] = auth['info']['image']
    new_params[:url] = 'https://twitter.com/' + auth['info']['nickname']
  when 'linkedin'
  else
    new_params[:name] = auth['info']['name']
  end
end

end
