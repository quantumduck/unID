class ProfilesController < ApplicationController
  # before_action :ensure_logged_in
  skip_before_action :verify_authenticity_token, only: :omniauth_create_post
  before_action :require_login

  def new
    @profile = Profile.new
  end

  def twitter_create
    @profile = Profile.new(twitter_params)
    @profile.user_id = current_user.id
    if @profile.save
      flash[:notice] = "successful oauth get request"
      redirect_to "/#{current_user.username}"
    else
      @auth = env('omniauth.auth')
      render :oauth_error
    end
  end

  def linkedin_create
    # render json: request.env['omniauth.auth']
    @profile = Profile.new(linkedin_params)
    @profile.user_id = current_user.id
    if @profile.save
      flash[:notice] = "successful oauth get request"
      redirect_to "/#{current_user.username}"
    else
      @auth = env('omniauth.auth')
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
    {
      uid: auth['uid'],
      provider: auth['provider'],
      name: auth['info']['name'],
      nickname: auth['info']['nickname'],
      image: auth['info']['image']
    }
  end

  def linkedin_params
    auth = env['omniauth.auth'].to_hash
    {
      uid: auth['uid'],
      provider: auth['provider'],
      first_name: auth['info']['first_name'],
      last_name: auth['info']['last_name'],
      name:  auth['info']['name'],
      email:  auth['info']['email'],
      description:  auth['info']['headline'],
      nickname: auth['info']['nickname'],
      image: auth['info']['image'],
      url: auth['info']['urls']['public_profile'],
      token: auth['credentials']['token']
    }
  end

end
