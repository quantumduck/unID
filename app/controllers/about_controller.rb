class AboutController < ApplicationController


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
