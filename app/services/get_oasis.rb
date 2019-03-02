class GetOasis
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, farm_coordinate
    @cookies = cookies
    @myvillage = myvillage
    @farm_coordinate = farm_coordinate
  end

  def get
    counter = 0
    total = (@farm_coordinate*2 + 1) ** 2
    loop_x = @myvillage.coordinate_x - @farm_coordinate
    loop_y = @myvillage.coordinate_y - @farm_coordinate

    while loop_x < @myvillage.coordinate_x + @farm_coordinate
      loop_y = @myvillage.coordinate_y - @farm_coordinate

      while loop_y < @myvillage.coordinate_y + @farm_coordinate
        counter += 1
        loop_y += 1
        if((@myvillage.coordinate_x - loop_x)**2 + (@myvillage.coordinate_y - loop_y)**2 > @farm_coordinate**2 )
          next
        end
        get_oasis loop_x, loop_y
      end
      loop_x += 1
    end
  end

  def get_oasis loop_x, loop_y
    responses = RestClient.get("https://ts6.travian.com.vn/position_details.php?x=#{loop_x}&y=#{loop_y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    sleep 0.25 +rand*1
    page = Nokogiri::HTML responses

    if is_oasis? page
      puts "Oasise.create! coordinate_x: #{loop_x}, coordinate_y: #{loop_y}, my_village_id: #{@myvillage.id}"
# fix army in here !
      Oasise.create! coordinate_x: loop_x, coordinate_y: loop_y, my_village_id: @myvillage.id, army4: 2
    end
  end

  def is_oasis? page
    if page.css(".titleInHeader").text.include? "ốc đảo bỏ hoang"
      return true
    end
    return false
  end
end
