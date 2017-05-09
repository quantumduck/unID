class UsersController < ApplicationController

  def new

    redirect_to new_user_registration_path

  end

  def create
    @user = User.new(user_params)
      @user.temp_password = rand(10000000000).to_s
      @user.password = @user.temp_password
      @user.password_confirmation = @user.temp_password
    if @user.save
      redirect_to "/#{@user.username}/#{@user.temp_password}/change_password"
    else
      render :new
    end
  end

  def change_password
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
    @user = User.find(params[:id])
    if @user && @user.authenticate(params[:user][:temp_password])

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

  private
  def user_params
    params.require(:user).permit(:email, :username)
  end

  def change_password_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email)
    end
  end

end
