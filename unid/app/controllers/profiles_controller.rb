class ProfilesController < ApplicationController

  def new
    @profile = Profile.new
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      redirect_to root
    else
      render :new
    end
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(profile_params)
      redirect_to root
    else
      render :edit
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    redirect_to root
  end

  def profile_params
    params.require(:profile).permit(:username, :name, :url, :description, :network )

end
