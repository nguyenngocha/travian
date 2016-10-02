class FarmsController < ApplicationController
  def index
    farm_all
    redirect_to my_villages_path
  end

  def farm_all
    @my_villages = current_user.my_villages
    @my_villages.each do |my_village|

      farm_for_village my_village
    end
  end

  def farm_for_village my_village
    @lands = my_village.lands
    @lands.each do |land|
      farm_for_land land, my_village
      sleep(3)
    end
  end

  def farm_for_land land, my_village
    get_cookies
    flash[:danger] = "send request fail" unless Farms.new(@cookies, my_village, land).send_request
    puts "farm success (#{land.coordinate_x}, #{land.coordinate_y})"
  end

  private
  def write_log response
    fptr = File.open "/home/ngocha/log.html", "w"
    fptr.puts response
  end
end
