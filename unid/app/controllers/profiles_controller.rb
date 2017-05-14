class ProfilesController < ApplicationController
  before_action :require_login

  def new
    @profile = Profile.new
  end

  def oauth_create(oauth_params)
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

  def tumblr_create
      # render plain: request.env["omniauth.auth"].to_hash
    @profile = Profile.new(tumblr_params)
    @profile.user_id = current_user.id
    if @profile.save
      flash[:notice] = "successful oauth get request"
      redirect_to "/#{current_user.username}"
    else
      @auth = env('omniauth.auth')
      render :oauth_error
    end
  end

  def facebook_create
      # render plain: request.env["omniauth.auth"].to_hash
    @profile = Profile.new(facebook_params)
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

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update(profile_params)
      redirect_to "/#{current_user.username}"
    else
      render edit
    end
  end

  def destroy
    profile = Profile.find(params[:id])
    if profile
      profile.destroy
    end
    redirect_to root_path
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
      first_name: auth['info']['first_name'],
      last_name: auth['info']['last_name'],
      provider: auth['provider'],
      name:  auth['info']['name'],
      email:  auth['info']['email'],
      description:  auth['info']['headline'],
      nickname: auth['info']['nickname'],
      image: auth['info']['image'],
      url: auth['info']['urls']['public_profile'],
      token: auth['credentials']['token']
    }
  end

  def tumblr_params
    auth = env['omniauth.auth'].to_hash
    {
      uid: auth['uid'],
      provider: auth['provider'],
      name: auth['info']['name'],
      nickname: auth['info']['nickname'],
      image: auth['info']['avatar'],
      url: "http://#{auth['info']['nickname']}.tumblr.com"
    }
  end

  def facebook_params
   auth = env['omniauth.auth'].to_hash
   {
     uid: auth['uid'],
     provider: auth['provider'],
     name: auth['info']['name'],
     description: auth['extra']['description'],
     image: auth['info']['image'],
     url: auth['extra']['link'],
   }
 end

end
