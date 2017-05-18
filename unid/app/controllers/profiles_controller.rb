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
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.allow_login = true if params[:allow_login]
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
    params.require(:profile).permit(:uid, :name, :description, :url, :network, :image_other)
  end


 end
