class ProfilesController < ApplicationController

  def new
    @profile = Profile.new
  end

  def omniauth_create
    @Profile = Profile.new
    @Profile.network = params[:provider]

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
    params.require(:profile).permit(:username, :name, :description, :url, :network)
  end

  def omniauth_params
    auth = request.env['omniauth.auth'].to_hash
  end

end
