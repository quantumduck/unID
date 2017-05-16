class UsersController < ApplicationController

  def new
    @user = User.new
    @homepage = true
    if current_user
      redirect_to "/#{current_user.username}"
    end
  end

  def create
    @user = User.new(user_params)
    @user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
    @user.password = @user.temp_password
    @user.password_confirmation = @user.temp_password
    if @user.save
      redirect_to "/#{@user.username}/#{@user.temp_password}/change_password"
    else
      render :new
    end
  end

  def reset_password
    user = current_user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
    user.password = user.temp_password
    user.password_confirmation = user.temp_password
    if user.save
      redirect_to "/#{user.username}/#{user.temp_password}/change_password"
    else

    end
  end



  def change_password
    if current_user

    else
      @user = User.find_by(username: params[:id])
      if @user.temp_password
        if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
        else
          redirect_to "/#{@user.username}"
        end
      else
        redirect_to "/#{@user.username}"
      end
    end
  end

  def show
    @user = User.find_by(username: params[:id])
    unless @user
      render :error404
    else
      redirect_if_temp
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

  def update_password
    @user = User.find_by(username: params[:id]
    if @user && @user.authenticate(params[:temp_password])
      if @user.update(change_password_params)
        @user.temp_password = nil
        @user.save
        redirect_to "/#{@user.username}"
      else
        render :change_password
      end
    else
      redirect_to "/#{@user.username}"
    end
  end

  def update
    @user = User.find_by(username: params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:email, :username)
  end

  def change_password_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

end
