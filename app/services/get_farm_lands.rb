class GetFarmLands
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, farm_coordinate
    @cookies = cookies
    @myvillage = myvillage
    @farm_coordinate = farm_coordinate
  end

  def get
    @myvillage.lands.delete_all
    counter = 0
    total = (@farm_coordinate*2 + 1) ** 2
    loop_x = @myvillage.coordinate_x - @farm_coordinate
    loop_y = @myvillage.coordinate_y - @farm_coordinate

    while loop_x < @myvillage.coordinate_x + @farm_coordinate
      loop_y = @myvillage.coordinate_y - @farm_coordinate

      while loop_y < @myvillage.coordinate_y + @farm_coordinate
        counter += 1
        loop_y += 1
        process = "#{counter}/#{total}"
        puts "#{loop_x}|#{loop_y} - #{process}\r"
        if((@myvillage.coordinate_x - loop_x)**2 + (@myvillage.coordinate_y - loop_y)**2 > @farm_coordinate**2 )
          next
        end
        check_farm loop_x, loop_y, process
      end
      loop_x += 1
    end
  end

  def check_farm loop_x, loop_y, process
    responses = RestClient.get("https://ts6.travian.com.vn/position_details.php?x=#{loop_x}&y=#{loop_y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML responses
    sleep rand*0.5 + 0.2
      ppls = population page
    if ppls.nil?
      return
    end
    if ppls.to_i < 100
      kbss = 2
    elsif ppls.to_i < 150
      kbss = 3
    elsif ppls.to_i < 200
      kbss = 5
    elsif ppls.to_i<280
      kbss = ppls.to_i/30
    else
      return
    end
    Land.create coordinate_x: loop_x , coordinate_y: loop_y, army4: kbss, my_village_id: @myvillage.id
    puts "Land.create coordinate_x: #{loop_x}, coordinate_y: #{loop_y}, army4: #{kbss}, my_village_id: #{@myvillage.id}"
  end

  def population page
    trs = page.css("#village_info tr")[3]
    if trs.nil?
      nil
    else
      trs.css("td").text
    end
  end

  def is_farm? page
    # farm_history = page.css(".tabContainer tr img")
    # farm_history.each do |a|
    #   return true if a["class"].include? "iReport1"
    # end
    # false
  end

  # def is_farm_oasis? x, y
  #   # https://ts6.travian.com.vn/karte.php?newdid=30788&x=-46&y=18
  #   responses = RestClient.get("https://ts6.travian.com.vn/position_details.php?x=#{x}&y=#{y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
  #   data = Nokogiri::HTML responses
  #   if data.css(".titleInHeader").text.include? "ốc đảo bỏ hoang"
  #     true
  #   else
  #     false
  #   end
  # end
end
