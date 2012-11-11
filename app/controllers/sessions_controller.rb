class SessionsController < ApplicationController

  def new
    redirect_to '/auth/github'
  end

  def create
    raise request.env["omniauth.auth"].to_yaml
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
