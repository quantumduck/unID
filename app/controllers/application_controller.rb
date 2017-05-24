class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :require_login, :user_page,
                :profiles_page, :profile_page, :edit_profile_page,
                :new_user, :provider_list

  def new_user
    User.new
  end

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

  def profile_page(profile)
    profiles_page(profile.user) + "/#{profile.id}"
  end

  def edit_profile_page(profile)
    profile_page(profile) + "/edit"
  end

  def provider_list
      [["Network", 0], ["Facebook", 1], ["Github", 2], ["Google", 3], ["Instagram", 4], ["LinkedIn", 5],
       ["Tumblr", 6], ["Twitch", 7], ["Twitter", 8], ["Youtube", 9]]
  end

end
