class FarmsController < ApplicationController
  before_action :logged_in_user

  def index
    farm_all
    flash[:success] = "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} : Hoan thanh 1 luot"
    redirect_to lands_path
  end

  def farm_all
    @my_villages = current_user.my_villages
    @my_villages.each do |my_village|
      farm_for_village my_village
    end
  end

  def farm_for_village my_village
    @lands = my_village.lands.order_by_distance
    @lands.each do |land|
      farm_for_land land, my_village
      sleep(3)
    end
  end

  def farm_for_land land, my_village
    get_cookies
    if Farms.new(@cookies, my_village, land).send_request
      puts "#{my_village.name}: farm success (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance}"
    else
      puts "#{my_village.name}: farm fail (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance}"
    end
  end
end
