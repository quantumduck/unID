class ProfilesController < ApplicationController

  def new
    @profile = Profile.new
  end

  def omniauth_create

  end

  def omniauth_create

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

end
