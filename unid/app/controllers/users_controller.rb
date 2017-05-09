class UsersController < ApplicationController

  def new
    if current_user
      redirect_to user_path(current_user.username)
    else
      redirect_to new_user_registration_path
    end

  end

  def show
    @user = User.find_by(username: params[:id])
    unless @user
      render :error404
    else

    end
  end

  def edit
    @user = User.find_by(username: params[:id])
    if current_user == @user
      @profile = Profile.new
      @profile.user_id = current_user.id
    else
      redirect_to "/#{@user.username}"
    end
  end

  def update


  end

end
