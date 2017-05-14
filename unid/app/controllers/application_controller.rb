class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :require_login, :user_page,
                :profiles_page, :profile_page, :edit_profile_page

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

  def user_page(user)
    "/#{user.username}"
  end

  def profiles_page(user = current_user)
    user_page(user) + '/profiles'
  end

  def profile_page(profile, user = current_user)
    profiles_page(user) + "/#{profile.id}"
  end

  def edit_profile_page(profile)
    profile_page(profile) + "/#{profile.id}/edit"
  end

end
