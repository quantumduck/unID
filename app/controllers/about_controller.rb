class AboutController < ApplicationController

  def google_verify
    render 'google26905ab3a96605d7', layout: false
  end

  def tos
    @user = User.find_by(username: 'about')
  end

  def privacy
    @user = User.find_by(username: 'about')
  end

  def contact
    @user = User.find_by(username: 'about')
  end

end
