class GetFarmLands
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, c_start, c_end
    @cookies = cookies
    @myvillage = myvillage
    @c_start = c_start
    @c_end = c_end
    @user = myvillage.user
  end

  def get
    @myvillage.lands.each do |land|
      if land.distance > @c_start && land.distance <= @c_end
        puts "delete #{land.coordinate_x}|#{land.coordinate_y}|#{land.distance}"
        land.destroy
      end
    end
    counter = 0
    total = (@c_end*2 + 1) ** 2
    loop_x = @myvillage.coordinate_x - @c_end
    loop_y = @myvillage.coordinate_y - @c_end
    checkList = Array.new

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
      check_farm x, y
    end
  end

  def check_farm loop_x, loop_y
    responses = RestClient.get("#{@user.server}/position_details.php?x=#{loop_x}&y=#{loop_y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
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
      kbss = 15
    end
    Land.create coordinate_x: loop_x , coordinate_y: loop_y, army5: kbss, my_village_id: @myvillage.id
    puts "Land.create coordinate_x: #{loop_x}, coordinate_y: #{loop_y}, army5: #{kbss}, my_village_id: #{@myvillage.id}"
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
  #   # #{@user.server}/karte.php?newdid=30788&x=-46&y=18
  #   responses = RestClient.get("#{@user.server}/position_details.php?x=#{x}&y=#{y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
  #   data = Nokogiri::HTML responses
  #   if data.css(".titleInHeader").text.include? "ốc đảo bỏ hoang"
  #     true
  #   else
  #     false
  #   end
  # end
end
