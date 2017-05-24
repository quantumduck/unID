class UsersController < ApplicationController

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
    @user.provider = auth.provider
    @user.uid = auth.uid
    @user.name = auth.info.name
    @user.oauth_token = auth.credentials.token
    @user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    @user.save!
    end
  end

  def new
    @user = User.new
    @homepage = true
    if current_user
      redirect_to "/#{current_user.username}"
    end
  end

  def create
    @user = User.new(user_params)
    @user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
    @user.password = @user.temp_password
    @user.password_confirmation = @user.temp_password
    if request.xhr?
      if @user.save
        UserMailer.signup_email(@user).deliver_later
        render plain: "#{root_url}#{@user.username}/#{@user.temp_password}/change_password"
      else
        render plain: "error"
      end
    else
      if @user.save
        UserMailer.signup_email(@user).deliver_later
        render plain: "#{root_url}#{@user.username}/#{@user.temp_password}/change_password"
      else
        render :new
      end
    end
  end

  def change_password
    @user = User.find_by(username: params[:id])
    if current_user == @user
      unless @user.temp_password == params[:password]
        redirect_to "/#{@user.username}"
      end
    else
      # new user
      unless @user.authenticate(params[:password])
        redirect_to root_path
      end
    end
  end

  def update_password
    @user = User.find_by(username: params[:id])
    if @user && @user.temp_password && @user.temp_password == params[:password]
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


  def show
    @user = User.find_by(username: params[:id])
    unless @user
      @user = User.new(username: params[:id])
      render :error404
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
    @user = User.find_by(username: params[:id])
    old_email = @user.email
    if @user.update(user_params)
      if (old_email != @user.email)
        UserMailer.email_change(@user, old_email).deliver_later
      end
      redirect_to "/#{@user.username}"
    else
      render edit
    end
  end

  def search
    unless params[:profile_network] && params[:profile_name]
      redirect_to root_path
    end
    name = params[:profile_name]
    provider = params[:profile_network]
    case provider
    when 'twitter'
      if name[0] == '@'
        nickname = name[1, name.length]
      else
        nickname = name
      end
      profiles = Profile.where(provider: 'twitter', nickname: nickname)
    when 'tumblr' || 'github' || 'instagram'
      profiles = Profile.where(provider: provider, nickname: name)
    else
      profiles = Profile.where(provider: provider, name: name)
    end
    if profiles.length > 0
      results = profiles.map { |p| "/#{p.user.username}" }
      render json: results
    else
      render plain: "none"
    end
  end


  private
  def user_params
    params.require(:user).permit(:email, :username, :name, :avatar)
  end

  def change_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
