class UsersController < ApplicationController

  def new
    @user = User.new

  end

  def create
    @user = User.new(user_params)
      @user.temp_password = rand.to_s
      @user.password = @user.temp_password
    if @user.save
      redirect_to "/#{@user.username}"
    else
      render :new
    end
  end

  def change_password

  end

  def show
    @user = User.find_by(username: params[:id])
    unless @user
      render :error404
    end
  end

  def edit
  end

  private
  def user_params
    params.require(:user).permit(:email, :username)
  end

end
