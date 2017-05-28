class AboutController < ApplicationController


  def tos
    @user = User.first
  end

  def privacy
    @uer = User.first
  end

  def contact
    @user = User.first
  end

end
