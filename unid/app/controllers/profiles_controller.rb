class ProfilesController < ApplicationController
  # before_action :ensure_logged_in
  skip_before_action :verify_authenticity_token, only: :omniauth_create_post

  def new
    @profile = Profile.new
  end

  def omniauth_create
    case params[:provider]
    when 'twitter'
      @profile = Profile.new(twitter_params)
    when 'google_oauth2'
      @profile = Profile.new(google_params)
    else
      @profile = Profile.new(profile_params)
    end
    if @profile.save
      redirect_to "/#{current_user.username}"
    else
      redirect_to new_profile_path(curent_user.username)
    end
  end

  def omniauth_create_post

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
