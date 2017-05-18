class UserMailer < ApplicationMailer
  # default from: 'unidteam@gmail.com'
  layout 'mailer'

  def signup_email(user)
    if user.name
      @name = user.name
    else
      @name = user.username
    end
    @link = "#{root_url}#{user.username}/#{user.temp_password}/change_password"
    mail(to: user.email, subject: 'Thank you for signing up to our awesome site!')
  end

  def reset_email(user)
    if user.name
      @name = user.name
    else
      @name = user.username
    end
    @link = "#{root_url}#{user.username}/#{user.temp_password}/change_password"
    mail(to: user.email, subject: 'Password Reset')
  end

  def email_change(user, old_email)

  end

end
