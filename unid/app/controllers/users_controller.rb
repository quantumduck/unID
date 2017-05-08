class UsersController < ApplicationController
  def new
    @user = User.new

  end

  def create
  end

  def show
    @user = User.find_by(username: params[:id])
    unless @user
      render :error404
    end
  end

  def edit
  end

end
