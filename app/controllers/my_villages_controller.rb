class MyVillagesController < ApplicationController
  before_action :logged_in_user
  def index
    @my_villages = current_user.my_villages
  end
end
