class FarmsController < ApplicationController
  def index
    @lands = Land.all
    get_cookies
    Farms.new(@cookies).send_request1
    redirect_to my_villages_path
  end
end
