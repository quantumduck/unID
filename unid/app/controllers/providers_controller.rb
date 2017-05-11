class ProvidersController < ApplicationController

  GOOGLE_AUTH_URI = 'https://accounts.google.com/o/oauth2/v2/auth'
  GOOGLE_BASE_URI = 'https://www.googleapis.com/'
  YT_SCOPE = [GOOGLE_BASE_URI + '/auth/youtube.readonly']
  GOOGLE_SCOPE = [GOOGLE_BASE_URI + '/auth/userinfo.email', GOOGLE_BASE_URI + '/auth/userinfo.profile']
  def oauth_google
    auth_uri = 'https://accounts.google.com/o/oauth2/v2/auth?' +\
      'redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fuselessendpoint%2F1&' +\
      'prompt=consent&response_type=code&client_id=' +\
      ENV['google_client_id'] +\
      '&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.readonly+' +\
      'https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.readonly&' +\
      'access_type=offline'
    response = HTTParty.get(request)
    render html: response.body.html_safe
  end

  def oauth_experiment1
    code = CGI.escape(params['code']) + '&'
    uri = 'https://www.googleapis.com/oauth2/v4/token'
    body = 'code=' + code +\
      'client_id='+ ENV['google_client_id'] +\
      '&client_secret=' + ENV['google_client_id_secret'] +\
      '&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fuselessendpoint%2F1' +\
      '&scope=&grant_type=authorization_code'
    headers = {'content-type' => 'application/x-www-form-urlencoded'}
    response1 = HTTParty.post(uri, body: body, headers: headers).parsed_response
    token = response1['access_token']
    uri = 'https://www.googleapis.com/youtube/v3/channels?part=id&mine=true'
    headers = {'Authorization' => 'Bearer ' + token}
    # helpme1111
    response2 = HTTParty.get(uri, headers: headers)
    render plain: response2.inspect
  end

private

  def authorize(auth_uri, scope_uri)

  end

end
