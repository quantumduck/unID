class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :require_login, :user_page,
                :profiles_page, :profile_page, :edit_profile_page,
                :new_user, :provider_list

  before_action :set_unidname

  def new_user
    User.new
  end

  def set_unidname
    if params[:user_id]
      @unidname = params[:user_id]
    elsif params[:id]
      @unidname = params[:id]
    else
      @unidname = "uniD"
    end
      user = User.find_by(username:@unidname)
    if user && user.avatar
      @avatar = user.avatar
    else
      @avatar = 'unidcorn-icon3'
    end
  end

  def current_user
    if session[:user_id] && User.exists?(session[:user_id])
      User.find(session[:user_id])
    else
      nil
    end
  end

  def redirect_if_temp
    if current_user && current_user.temp_password
      redirect_to "/#{current_user.username}/#{current_user.temp_password}/change_password"
    end
  end

  def require_login
    unless current_user
      flash[:alert] = "Please log in first."
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
      [["Twitter", 0], ["Youtube", 1], ["Facebook", 2], ["Google", 3],
       ["Tumblr", 4], ["Twitch", 5], ["Github", 6], ["LinkedIn", 7],
       ["Instagram", 8]]
  end

end
