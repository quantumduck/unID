class ProvidersController < ApplicationController
  before_action :require_login
  skip_before_action :verify_authenticity_token, only: :callback

  SETTINGS = {
    'google' => {
      auth_uri: 'https://accounts.google.com/o/oauth2/v2/auth',
      base_uri: 'https://www.googleapis.com',
      scopes: ['https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/plus.me'],
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
      scopes: ['https://www.googleapis.com/auth/youtube.readonly'],
      callback: 'http://localhost:3000/auth/youtube/callback',
      params: {'prompt' => 'consent', 'response_type' => 'code', 'access_type' => 'offline'},#
      token_path: '/oauth2/v4/token',
      token_headers: {'content-type' => 'application/x-www-form-urlencoded'},
      client_id: ENV['google_client_id'],
      client_secret: ENV['google_client_id_secret'],
      id_query: '/youtube/v3/channels?part=id%2CbrandingSettings&mine=true',
      profile_prefix: 'https://www.youtube.com/channel/'
    },
    'linkedin' => {
      auth_uri: 'https://www.linkedin.com/oauth/v2/authorization',
      base_uri: 'https://api.linkedin.com/v1/',
      scopes:['r_basicprofile', 'r_emailaddress'],
      callback: 'http://localhost:3000/auth/linkedin/callback',
      params: {'response_type' => 'code'},
      client_id: ENV['linkedin_client_id'],
      client_secret: ENV['linkedin_secret'],
      token_path: '/oauth2/v4/token',
      token_headers: {'content-type' => 'application/x-www-form-urlencoded'},
      profile_prefix: 'https://www.linkedin.com/in/',
      state: 'ef08qu34541325'
    }
  }


  def authorize
    settings = SETTINGS[params[:provider]]
    scopes = settings[:scopes].map { |s| CGI.escape(s) }
    scopes = scopes.join('%20')
    query = '?redirect_uri='
    query += CGI.escape(settings[:callback]) + '&'
    settings[:params].each { |k, v| query += k + '=' + v + '&'}
    query += 'scope=' + scopes + '&'
    query += 'client_id=' + settings[:client_id]
    query += '&state=' + settings[:state]
    response = HTTParty.get(settings[:auth_uri] + query)
    # render plain: settings[:auth_uri] + query
    render html: response.body.html_safe
  end

  def callback
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

  def linkedin_callback

    render plain: params.inspect

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
      when 'linkedin'
        render plain: api_response.inspect


      end
    else
      render plain: "ERROR: #{api_response.code}\n\n#{api_response.inspect}"
    end
  end

private


end
