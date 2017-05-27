class ProvidersController < ApplicationController

  SETTINGS = {
    'google' => {
      auth_uri: 'https://accounts.google.com/o/oauth2/v2/auth',
      base_uri: 'https://www.googleapis.com',
      scopes: ['https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/plus.me', 'https://www.googleapis.com/auth/userinfo.email'],
      callback: ENV['base_uri'] + '/auth/google/callback',
      params: {'prompt' => 'consent', 'response_type' => 'code', 'access_type' => 'offline'},
      token_path: '/oauth2/v4/token',
      token_headers: {'content-type' => 'application/x-www-form-urlencoded'},
      client_id: ENV['google_client_id'],
      client_secret: ENV['google_client_id_secret'],
      id_query: '/plus/v1/people/me?fields=displayName%2Cid%2Cimage%2Cname%2Cemails',
      profile_prefix: 'https://plus.google.com/u/',
      state: ''
    },
    'youtube' => {
      auth_uri: 'https://accounts.google.com/o/oauth2/v2/auth',
      base_uri: 'https://www.googleapis.com',
      scopes: ['https://www.googleapis.com/auth/youtube.readonly'],
      callback: ENV['base_uri'] + '/auth/youtube/callback',
      params: {'prompt' => 'consent', 'response_type' => 'code', 'access_type' => 'offline'},#
      token_path: '/oauth2/v4/token',
      token_headers: {'content-type' => 'application/x-www-form-urlencoded'},
      client_id: ENV['google_client_id'],
      client_secret: ENV['google_client_id_secret'],
      id_query: '/youtube/v3/channels?part=id%2Csnippet&mine=true',
      profile_prefix: 'https://www.youtube.com/channel/',
      state: ''
    }

  }


  def authorize
    # This route is only used for providers without an oauth2 gem.
    if params[:provider] != 'youtube' || current_user
      settings = SETTINGS[params[:provider]]
      scopes = settings[:scopes].map { |s| CGI.escape(s) }
      scopes = scopes.join('+')
      query = '?redirect_uri='
      query += CGI.escape(settings[:callback]) + '&'
      settings[:params].each { |k, v| query += k + '=' + v + '&'}
      query += 'scope=' + scopes + '&'
      query += 'client_id=' + ENV['google_client_id']
      response = HTTParty.get(settings[:auth_uri] + query)
      render html: response.body.html_safe
    else
      # New users cannot add youtube accounts
      redirect_to '/auth/google'
    end
  end


  def callback
    # IMPORTANT! Do not render views from this route in production code!
    provider = params[:provider]
    if provider == 'youtube' || provider == 'google'
      get_token(provider)
    else
      oauth_params = get_params(provider)
      if provider == 'facebook'
        facebook_api = Koala::Facebook::OAuth.new
        oauth_params[:token] = facebook_api.exchange_access_token(oauth_params[:token])
      end
        if current_user
          # If user is signed in, create a new profile.
          create_profile(oauth_params)
        else
          login_user(oauth_params)
        end
    end
  end

private

  def get_params(provider)
    auth = env['omniauth.auth'].to_hash
    new_params = {
      uid: auth['uid'],
      provider: auth['provider'],
      name: auth['info']['name'],
      token: auth['credentials']['token'],
    }
    case provider
    when 'twitter'
      new_params[:nickname] = auth['info']['nickname']
      new_params[:image] = auth['info']['image']
      new_params[:url] = 'https://twitter.com/' + auth['info']['nickname']
      new_params[:email] = auth['info']['email']
      new_params[:description] = auth['info']['description']
    when 'linkedin'
      new_params[:first_name] = auth['info']['first_name']
      new_params[:last_name] = auth['info']['last_name']
      new_params[:email] = auth['info']['email']
      new_params[:image] = auth['info']['image']
      new_params[:description] = auth['info']['description']
      new_params[:nickname] = auth['info']['nickname']
      new_params[:url] = auth['info']['urls']['public_profile']
    when 'tumblr'
      new_params[:nickname] = auth['info']['nickname']
      new_params[:image] = auth['info']['avatar']
      new_params[:url] = "http://#{auth['info']['nickname']}.tumblr.com"
    when 'facebook'
      new_params[:description] = auth['extra']['description']
      new_params[:image] = auth['info']['image']
      new_params[:url] = 'https://facebook.com/' + auth['uid']
    when 'twitch'
      puts auth
      new_params[:description] = auth['info']['description']
      new_params[:image] = auth['info']['image']
      new_params[:url] = "https://www.twitch.tv/" + auth["info"]["name"]
      new_params[:expires] = false
      puts auth

    when 'github'
      new_params[:image] = auth['info']['image']
      new_params[:description] = auth['info']['repos_url']
      new_params[:nickname] = auth['info']['nickname']
      new_params[:url] = "https://github.com/" + auth['info']['nickname']
  when 'instagram'
      new_params[:nickname] = auth ['user']['id']

  end
    new_params
  end

  def login_user(user_params)
    profile = Profile.shared(user_params).first
    if profile
      if profile.allow_login
        user = profile.user
        session[:user_id] = user.id
        redirect_to "/#{user.username}"
      else
        flash[:alert] = "You cannot log in with this profile."
        redirect_to root_path
      end
    else
      user_params[:allow_login] = true
      create_user(user_params)
    end
  end

  def create_user(user_params)
    user = User.new
    new_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
    user.name = user_params[:name]
    user.password = new_password
    user.password_confirmation = new_password
    # if user_params[:email] == nil
    #   user.email = "#{params[:nickname]}@example.com"
    # else
      user.email = user_params[:email]
    # end

    if User.find_by(email: user.email)
      flash[:alert] = "The email associated with that account already exists"
      redirect_to root_path
    else

      user.username = user.email.split('@').first.tr("!#$%&'*+-/=?^_`{|}~", "")
      user.username = User.find_unique(user.username)
      if user.save
        session[:user_id] = user.id
        create_profile(user_params)
      else
        @user = user
        @homepage = true
        @login_class = "hidden-card"
        @signup_class = "card"
        flash.now[:alert] = "An error occurred creating user account."
        render 'users/new'
      end
    end
  end

  def create_profiles(profile_params)
    profile_params[:multiple].each do |mult|
      new_params = mult
      new_params[:token] = profile_params[:token]
      new_params[:refresh_token] = profile_params[:refresh_token]
      new_params[:expires] = profile_params[:expires]
      new_params[:expires_at] = profile_params[:expires_at]
      new_params[:provider] = profile_params[:provider]
      create_profile(new_params)
    end
  end

  def create_profile(profile_params)
    if current_user
      matching_profiles = Profile.all.shared(profile_params)
      if matching_profiles.length == 0
        profile = Profile.new(profile_params)
        profile.user_id = current_user.id
        if profile.save
          redirect_to "/#{current_user.username}"
        else
          flash[:alert] = "Error: Profile coult not be saved.\n\nData: #{oauth_params}"
          redirect_to "/#{current_user.username}"
        end
      else
        profile = matching_profiles.same_user(current_user).first
        if profile
          if profile.update(profile_params)
            redirect_to "/#{current_user.username}"
          else
            flash[:alert] = "Error: Profile could not be updated.\n\nData: #{oauth_params}"
          end
        elsif matching_profiles.first.allow_login
          flash[:alert] = "Error: This profile has been reserved."
          redirect_to "/#{current_user.username}"
        else
          profile = Profile.new(profile_params)
          profile.user_id = current_user.id
          profile.allow_login = false
          if profile.save
            redirect_to "/#{current_user.username}"
          else
            render plain: "Error: Profile could not be saved.\n\nData: #{oauth_params}"
          end
        end
      end
    else
      flash[:alert] = "You must be logged in before you can create a profile."
      redirect_to root_path
    end
  end

  #### Google and Youtube ####

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
    if token_response.code == 200
      oauth_params = {
        token: token_info['access_token'],
        expires_at: Time.now + token_info['expires_in'],
        expires: true,
        refresh_token: token_info['refresh_token'],
        provider: params[:provider]
      }
      call_id_api(oauth_params)
    else
      flash[:alert] =  "ERROR: no token\n\n#{token_response.inspect}"
      redirect_to root_path
    end
  end

  def call_id_api(oauth_params)
    settings = SETTINGS[oauth_params[:provider]]
    uri = settings[:base_uri] + settings[:id_query]
    headers = {
      'Authorization' => 'Bearer ' + oauth_params[:token]
    }
    api_response = HTTParty.get(uri, headers: headers)
    if api_response.code == 200
      case oauth_params[:provider]

      when 'youtube'
        oauth_params[:multiple] =
        api_response.parsed_response['items'].map do |channel|
          {
            uid: channel['id'],
            url: settings[:profile_prefix] + channel['id'],
            name: channel['snippet']['title'],
            image: channel['snippet']['thumbnails']['default']['url']
          }
        end
        if oauth_params[:multiple].length > 0
          create_profiles(oauth_params)
        else
          flash[:alert] = "ERROR: no youtube channels found\n\n#{api_response.inspect}"
          redirect_to root_path
        end

      when 'google'
        oauth_params[:uid] = api_response.parsed_response['id']
        oauth_params[:url] = settings[:profile_prefix] + oauth_params[:uid]
        oauth_params[:name] = api_response.parsed_response['displayName']
        oauth_params[:first_name] = api_response.parsed_response['givenName']
        oauth_params[:last_name] = api_response.parsed_response['familyName']
        oauth_params[:image] = api_response.parsed_response['image']['url']
        oauth_params[:email] = api_response.parsed_response['emails'][0]['value']
        oauth_params[:allow_login] = true
        if current_user
          create_profile(oauth_params)
        else
          login_user(oauth_params)
        end
      else
        flash[:alert] = "ERROR: Unsupported provider: #{oauth_params[:provider]}"
        redirect_to root_path
      end
    else
      flash[:alert] = "ERROR: #{api_response.code}\n\n#{api_response.inspect}"
      redirect_to root_path
    end
  end
  # def get_long_lived_token(token)
  #   uri = 'https://facebook.com/v2.3/oauth/access_token?grant_type=fb_exchange_token&' +
  #       "client_id=#{ENV['facebook_app_id']}&" +
  #       "client_secret=#{ENV['facebook_app_secret']}&" +
  #       "fb_exchange_token=#{token}"
  #       headers = {'Accept' => 'application/json'}
  #     response = HTTParty.get(uri, headers: headers)
  #     # dfghjkl;lkjhgf
  # end


end
