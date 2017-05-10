class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :omnipost

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

  def omniget
    auth_hash = request.env['omniauth.auth']

    case params[:provider]
    when 'google_oauth2'

    end
    debugnow
  end

  def omnipost
    debugnow
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

end
