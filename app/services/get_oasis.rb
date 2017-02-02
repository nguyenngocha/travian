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
        process = "#{counter}/#{total}"
        get_oasis loop_x, loop_y, process
        loop_y += 1
        sleep rand*3
      end
      loop_x += 1
      sleep rand*3
    end
  end

  def get_oasis loop_x, loop_y, process
    responses = RestClient.get("http://ts19.travian.com.vn/position_details.php?x=#{loop_x}&y=#{loop_y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML responses
    if is_oasis? page
      puts "Oasise.create! coordinate_x: #{loop_x}, coordinate_y: #{loop_y}, my_village_id: #{@myvillage.id}"
# fix army in here !
      Oasise.create! coordinate_x: loop_x, coordinate_y: loop_y, my_village_id: @myvillage.id, army1: 2
      puts "#{loop_x}|#{loop_y}|#{@myvillage.name} ~ true - #{process}"
    else
      puts "#{loop_x}|#{loop_y}|#{@myvillage.name} ~ false - #{process}"
    end
  end

  def is_oasis? page
    return true if page.css(".titleInHeader").text.include? "ốc đảo bỏ hoang"
    return false
  end
end
