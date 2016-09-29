class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def current_cookies cookies
    @cookies = cookies
  end
end
