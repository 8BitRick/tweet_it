class SessionsController < ApplicationController

  require 'pp'
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    oa = env['omniauth.auth']
    #p oa['credentials']['token']
    #p oa['credentials']['secret']
    session[:user_id] = user.id
    session[:token] = oa['credentials']['token']
    session[:secret] = oa['credentials']['secret']
    redirect_to root_url, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

end
