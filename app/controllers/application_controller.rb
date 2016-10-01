class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def set_cookies cookies
    session[:user] = cookies
  end

  def get_cookies
    @cookies = session[:user]
  end
end
