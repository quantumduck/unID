class ProfilesController < ApplicationController
  before_action :require_login

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    @profile.uid = current_user.id
    if @profile.save
      redirect_to "/#{current_user.username}"
    else
      render "users/edit"
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    if current_user != @profile.user
      redirect_to user_page(@profile.user)
    end
  end

  def update
    @profile = Profile.find(params[:id])
    if current_user != @profile.user
      redirect_to user_page(@profile.user)
    else
      @profile.allow_login = true if params[:allow_login]
      if @profile.update(profile_params)
        redirect_to "/#{current_user.username}"
      else
        render edit
      end
    end
  end

  def destroy
    profile = Profile.find(params[:id])
    if current_user != @profile.user
      redirect_to user_page(@profile.user)
    else
      profile.destroy
      redirect_to root_path
    end
  end

private

  def profile_params
    params.require(:profile).permit(:uid, :name, :description, :url, :network, :image_other)
  end


 end
