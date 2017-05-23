class ProfilesController < ApplicationController
  before_action :require_login

  def new
    @profile = Profile.new
  end

  def other
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params('other'))
    @profile.user_id = current_user.id
    @profile.uid = current_user.username
    @profile.provider = 'other'
    if request.xhr?
      if @profile.save
        render plain: 'saved'
      else
        render json: @profile.errors
      end
    else
      if @profile.save
        redirect_to "/#{current_user.username}"
      else
        render "users/edit"
      end
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    unless current_user && current_user == @profile.user
      redirect_to user_page(@profile.user)
    end
  end

  def update
    @profile = Profile.find(params[:id])
    unless current_user && current_user == @profile.user
      redirect_to user_page(@profile.user)
    else
      if request.xhr?
        if @profile.update(profile_params(@profile.provider))
          render plain: 'saved'
        else
          render json: @profile.errors
        end
      else
        if @profile.update(profile_params(@profile.provider))
          redirect_to "/#{current_user.username}"
        else
          render edit
        end
      end
    end
  end

  def destroy
    profile = Profile.find(params[:id])
    unless current_user && current_user == profile.user
      redirect_to user_page(@profile.user)
    else
      profile.destroy
      redirect_to root_path
    end
  end

private

  def profile_params(provider)
    if type == other
      params.require(:profile).permit(:nickname, :name, :description, :url, :image_other)
    else
      params.require(:profile).permit(:description)
    end
  end

 end
