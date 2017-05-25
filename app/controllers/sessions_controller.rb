class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/#{user.username}", notice: "Logged in!"
    else
      @user = User.new
      render "users/new"
    end
  end

  def reset_request

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

  def reset_password
    user = User.find_by(email: params[:email])
    if current_user
      if current_user == user
        user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
        if user.save
          UserMailer.reset_email(user).deliver_later
          # or send an email!
        else
          flash
          redirect_to root_path
        end
      else
        session[:user_id] = nil
        redirect_to root_path
      end
    else
      user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
      user.password = user.temp_password
      user.password_confirmation = user.temp_password
      if user.save
        UserMailer.reset_email(user).deliver_later
        # or send an email!
      else
        redirect_to root_path
      end
    end
  end
end
