class FarmsController < ApplicationController
  before_action :logged_in_user

  def index
    farm_all
    flash[:success] = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} : Hoan thanh 1 luot"
    redirect_to lands_path
  end

  def farm_all
    get_cookies
    @my_villages = current_user.my_villages
    @my_villages.each do |my_village|
      my_village.farm_for_village cookies
    end
  end
end
