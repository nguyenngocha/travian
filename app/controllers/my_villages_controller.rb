class MyVillagesController < ApplicationController
  def index
    @my_villages = current_user.my_villages
  end
end
