class UserMailer < ApplicationMailer


  def sign_up(user)
    if user.name
      @name = user.name
    else
      @name = user.username
    end
    @link = "#{root_url}#{user.username}/#{user.temp_password}/change_password"
  end

end
