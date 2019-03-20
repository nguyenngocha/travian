class GetOasis
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, farm_coordinate
    @cookies = cookies
    @myvillage = myvillage
    @c_start = 0
    @c_end = farm_coordinate
    @user = myvillage.user
  end

  def get
    counter = 0
    loop_x = @myvillage.coordinate_x - @c_end
    loop_y = @myvillage.coordinate_y - @c_end

    while loop_x < @myvillage.coordinate_x + @c_end
      loop_y = @myvillage.coordinate_y - @c_end

      while loop_y < @myvillage.coordinate_y + @c_end
        loop_y += 1
        if (@myvillage.coordinate_x - loop_x)**2 + (@myvillage.coordinate_y - loop_y)**2 > @c_end**2
          next
        end
        
        if (@myvillage.coordinate_x - loop_x)**2 + (@myvillage.coordinate_y - loop_y)**2 < @c_start**2
          next
        end
        checkList << [loop_x, loop_y]
      end
      loop_x += 1
    end
    checkList.shuffle.each do |x, y|
      get_oasis x, y
    end
  end

  def get_oasis loop_x, loop_y
    responses = RestClient.get("#{@user.server}/position_details.php?x=#{loop_x}&y=#{loop_y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    sleep 0.25 + rand*1
    page = Nokogiri::HTML responses

    if is_oasis? page
      puts "Oasise.create! coordinate_x: #{loop_x}, coordinate_y: #{loop_y}, my_village_id: #{@myvillage.id}"
# fix army in here !
      Oasise.create! coordinate_x: loop_x, coordinate_y: loop_y, my_village_id: @myvillage.id
    end
  end

  def is_oasis? page
    if page.css(".titleInHeader").text.include? "ốc đảo bỏ hoang"
      return true
    end
    return false
  end
end
