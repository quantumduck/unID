class ProfilesController < ApplicationController
  # before_action :ensure_logged_in
  skip_before_action :verify_authenticity_token, only: :omniauth_create_post
  before_action :require_login

  def new
    @profile = Profile.new
  end

  def omniauth_create
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
      flash[:notice] << "successful oauth get request"
      redirect_to "/#{current_user.username}"
    else
      @auth = env('omniauth.auth')
      render :oauth_error
    end
  end

  def omniauth_create_post
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
      flash[:notice] << "successful oauth post request"
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


private
  def profile_params
    params.require(:profile).permit(:uid, :name, :description, :url, :network)
  end

  def twitter_params
    auth = env['omniauth.auth'].to_hash
    {uid: auth.uid, provider: auth.provider, name: auth.name, nickname: auth.nickname, image: auth.image}
  end

  def google_params
    auth = env['omniauth.auth'].to_hash
    {uid: auth.uid, provider: auth.provider, name: auth.name, email: auth.email, image: auth.image}
  end

end
