class ReturnsController < ApplicationController


  def show
  puts env['omniauth.auth']
  @return = env['omniauth.auth'].to_hash




  end
end
