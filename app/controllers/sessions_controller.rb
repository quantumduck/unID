class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if request.xhr?
        render json: { redirect: "#{ENV["base_uri"]}/#{user.username}" }
      else
        redirect_to "/#{user.username}", notice: "Logged in!"
      end
    else
      if request.xhr?
        render json: { errors: ["Invalid email or password."] }
      else
        @user = User.new
        @login_class = "card"
        @signup_class = "hidden-card"
        @homepage = true
        flash.now[:alert] = "Invalid email or password"
        render "users/new"
      end
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
          flash[:notice] = "A password reset email was sent to #{user.email}"
          redirect_to root_path
        else
          flash[:alert] = "An error occurred resetting your password. Please try again."
          redirect_to root_path
        end
      else
        @user = User.new
        @login_class = "card"
        @signup_class = "hidden-card"
        @homepage = true
        flash.now[:alert] = "This is not the email we have on file."
        render "users/new"
      end
    elsif user
      user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
      user.password = user.temp_password
      user.password_confirmation = user.temp_password
      if user.save
        UserMailer.reset_email(user).deliver_later
        flash[:notice] = "A password reset email was sent to #{user.email}"
        session[:user_id] = user.id
      else
        flash[:notice] = "A password reset email was sent to #{user.email}"
        redirect_to root_path
      end
    end
  end
end
