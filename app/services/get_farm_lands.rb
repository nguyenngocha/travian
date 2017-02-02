class GetFarmLands
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, farm_coordinate
    @cookies = cookies
    @myvillage = myvillage
    @farm_coordinate = farm_coordinate
  end

  def get
    file_save_data = File.open "db/test.txt", "w"
    counter = 0
    total = (@farm_coordinate*2 + 1) ** 2
    loop_x = @myvillage.coordinate_x - @farm_coordinate
    loop_y = @myvillage.coordinate_y - @farm_coordinate

    while loop_x < @myvillage.coordinate_x + @farm_coordinate
      loop_y = @myvillage.coordinate_y - @farm_coordinate

      while loop_y < @myvillage.coordinate_y + @farm_coordinate
        counter += 1
        process = "#{counter}/#{total}"
        check_farm loop_x, loop_y, file_save_data, process
        loop_y += 1
        sleep 3 + rand*1
      end
      loop_x += 1
      sleep 100
    end
  end

  def check_farm loop_x, loop_y, file_save_data, process
    responses = RestClient.get("http://ts19.travian.com.vn/position_details.php?x=#{loop_x}&y=#{loop_y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML responses
    if is_farm? page
      ppls = population page
      file_save_data.puts "#{loop_x}|#{loop_y}|#{ppls}"
      puts "#{loop_x}|#{loop_y}|#{ppls} ~ true - #{process}"
    else
      puts "#{loop_x}|#{loop_y} ~ false - #{process}"
    end
  end

  def population page
    trs = page.css("#village_info tr")[3]
    if trs.nil?
      "*"
    else
      trs.css("td").text
    end
  end

  def is_farm? page
    farm_history = page.css(".tabContainer tr img")
    farm_history.each do |a|
      return true if a["class"].include? "iReport1"
    end
    false
  end

  # def is_farm_oasis? x, y
  #   # http://ts19.travian.com.vn/karte.php?newdid=30788&x=-46&y=18
  #   responses = RestClient.get("http://ts19.travian.com.vn/position_details.php?x=#{x}&y=#{y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
  #   data = Nokogiri::HTML responses
  #   if data.css(".titleInHeader").text.include? "ốc đảo bỏ hoang"
  #     true
  #   else
  #     false
  #   end
  # end
end
