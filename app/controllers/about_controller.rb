class AboutController < ApplicationController


  def tos
    @user = User.find_by(username: 'about')
  end

  def privacy
    @uer = User.find_by(username: 'about')
  end

  def contact
    @user = User.find_by(username: 'about')
  end

end
