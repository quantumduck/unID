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
    @login_class = "hidden-card"
    @signup_class = "hidden-card"
    @homepage = true
    if current_user
      redirect_to "/#{current_user.username}"
    end
  end

  def create
    @user = User.new(user_params)
    @homepage = true
    @user.temp_password = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0")
    @user.password = @user.temp_password
    @user.password_confirmation = @user.temp_password
    if request.xhr?
      if @user.save
        UserMailer.signup_email(@user).deliver_later
        render json: { email: @user.email }
      else
        render json: { errors: @user.errors.full_messages.map { |m| "-- " + m } }
      end
    else
      if @user.save
        UserMailer.signup_email(@user).deliver_later
        flash[:notice] = "An email was sent to #{@user.email} with further instructions."
        redirect_to root_path
      else
        @login_class = "hidden-card"
        @signup_class = "card"
        flash.now[:alert] = @user.errors.full_messages.join("\n")
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
        if request.xhr?
          session[:user_id] = @user.id
          render json: { redirect: "#{ENV["base_uri"]}/#{user.username}" }
        else
          session[:user_id] = @user.id
          redirect_to "/#{@user.username}"
        end
      else
        if request.xhr?
          render json: { errors: @user.errors.full_messages }
        else
          render :change_password
        end
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
    if request.xhr?
      if @user.update(user_params)
        if (old_email != @user.email)
          UserMailer.email_change(@user, old_email).deliver_later
        end
        render plain: "saved"
      else
        render json: { errors: @user.errors.full_messages.map { |m| "-- " + m } }
      end
    else
      if @user.update(user_params)
        if (old_email != @user.email)
          UserMailer.email_change(@user, old_email).deliver_later
        end
        redirect_to "/#{@user.username}"
      else
        render edit
      end
    end
  end

  def search
    unless params[:profile_network_id] && params[:profile_name]
      redirect_to root_path
    end
    name = params[:profile_name]
    provider = provider_list[params[:profile_network_id].to_i][0].downcase
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
    if request.xhr?
      if profiles.length > 0
        results = profiles.map { |p| "/#{p.user.username}" }
        render json: { results: results }
      else
        render plain: "none"
      end
    else
      if profiles.length > 0
        redirect_to "/#{profiles[0].user.username}"
      else
        redirect_to root_path
      end
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
