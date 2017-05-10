class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :require_login

  def current_user
    session[:user_id] && User.find(session[:user_id])
  end

  def redirect_if_temp
    if current_user && current_user.temp_password
      redirect_to "/#{current_user.username}/#{current_user.temp_password}/change_password"
    end
  end

  def require_login
    unless current_user
      redirect_to root_path
    end
  end

end
