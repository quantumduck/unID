class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if request.xhr?
        render json: { redirect: "#{ENV["base_uri"]}/#{user.username}" }
      else
        redirect_to "/#{user.username}"
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
    redirect_to root_path
  end

  def reset_password
    user = User.find_by(email: params[:email].downcase)
    if current_user
      if current_user == user
        user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
        if user.save
          UserMailer.reset_email(user).deliver_later
          if request.xhr?
            render json: {email: user.email}
          else
            flash[:notice] = "A password reset email was sent to #{user.email}"
            redirect_to root_path
          end
        else
          if request.xhr?
            render json: {errors: ["An error occurred resetting your password. Please try again."]}
          else
            flash[:alert] = "An error occurred resetting your password. Please try again."
            redirect_to root_path
          end
        end
      else
        @user = User.new
        @login_class = "card"
        @signup_class = "hidden-card"
        @homepage = true
        if request.xhr?
          render json: {errors: ["This is not the email we have on file."]}
        else
          flash.now[:alert] = "This is not the email we have on file."
          render "users/new"
        end
      end
    elsif user
      user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
      user.password = user.temp_password
      user.password_confirmation = user.temp_password
      if user.save
        UserMailer.reset_email(user).deliver_later
        if request.xhr?
          render json: {email: user.email}
        else
          flash[:notice] = "A password reset email was sent to #{user.email}"
          redirect_to root_path
        end
      else
        if request.xhr?
          render json: {errors: ["An error occurred resetting your password. Please try again."]}
        else
          flash[:alert] = "An error occurred resetting your password. Please try again."
          redirect_to root_path
        end
      end
    else
      if request.xhr?
        render json: {email: params[:email]}
      else
        flash[:notice] = "A password reset email was sent to #{params[:email]}"
        redirect_to root_path
      end
    end
  end
end
