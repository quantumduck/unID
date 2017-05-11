class ProfilesController < ApplicationController
  # before_action :ensure_logged_in
  skip_before_action :verify_authenticity_token, only: :omniauth_create_post
  before_action :require_login

  def new
    @profile = Profile.new
  end

  def oauth_create
    case params[:provider]
    when 'twitter'
      @profile = Profile.new(twitter_params)
      @profile.user_id = current_user.id
    when 'google_oauth2'
      @profile = Profile.new(google_params)
      @profile.user_id = current_user.id
    else
      @profile = Profile.new(profile_params)
    end
    if @profile.save
      flash[:notice] = "successful oauth get request"
      redirect_to "/#{current_user.username}"
    else
      @auth = env('omniauth.auth')
      render :oauth_error
    end
  end

  def oauth_create_post
    case params[:provider]
    when 'twitter'
      @profile = Profile.new(twitter_params)
      @profile.user_id = current_user.id
    when 'google_oauth2'
      @profile = Profile.new(google_params)
      @profile.user_id = current_user.id
    else
      @profile = Profile.new(profile_params)
    end
    if @profile.save
      flash[:notice] = "successful oauth post request"
      redirect_to "/#{current_user.username}"
    else
      render :oauth_error
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    if @profile.save
      redirect_to "/#{current_user.username}"
    else
      render "users/edit"
    end
  end

  def update
  end

  def destroy
  end

  def oauth_trigger
    request = 'https://accounts.google.com/o/oauth2/v2/auth?' +\
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

  def oauth_experiment2

  end




private
  def profile_params
    params.require(:profile).permit(:uid, :name, :description, :url, :network)
  end

  def twitter_params
    auth = env['omniauth.auth'].to_hash
    {
      uid: auth['uid'],
      provider: auth['provider'],
      name: auth['info']['name'],
      nickname: auth['info']['nickname'],
      image: auth['info']['image']
    }
  end

  def google_params
    auth = env['omniauth.auth'].to_hash
    asfakshflh
    {
      uid: auth['uid'],
      provider: auth['provider'],
      name: auth['info']['name'],
      email: auth['info']['email'],
      image: auth['info']['image']
    }
  end

end
