class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def set_cookies cookies
    session[:cookies] = cookies
  end

  def get_cookies
    @cookies = session[:cookies]
  end

  private
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Dang nhap truoc da"
      redirect_to login_url
    end
  end
end
