class Farms
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, land, active
    @cookies = cookies
    @myvillage = myvillage
    @land = land
    @active = active
  end

  def check_number_army?
    response = RestClient.get("https://ts6.travian.com.vn/build.php" + @myvillage.link + "id=39&tt=2&gid=16",
      cookies: @cookies)
    page = Nokogiri::HTML response
    if page.css("div#header ul#navigation").empty? #kiem tra tinh trang dang nhap
      puts "Da bi dang xuat(farm.rb)"
      puts "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"
      sleep 0.2
      logout_res = RestClient.get "https://ts6.travian.com.vn"
      logout_page = Nokogiri::HTML logout_res
      login = logout_page.css("input[name='login'] @value").text
      sleep 0.2
      @login_res = RestClient.post "https://ts6.travian.com.vn/dorf1.php",
        {name: @myvillage.user.name, password: @myvillage.user.password,
        s1: "Đăng+nhập", w: "1366:768", login: login, lowRes: "0"}
      login_page = Nokogiri::HTML @login_res
      unless login_page.css("div#header ul#navigation").empty?
        @myvillage.user.update_attributes! t3e: @login_res.cookies["T3E"], sess_id: @login_res.cookies["sess_id"]
        puts "Da dang nhap lai(farm.rb)"
      end
    end
    @current_armies = page.css("table#troops td")
    if !@current_armies.empty?
      if @land.army1 > @current_armies[0].css("a[href= '#']").text[1...-1].to_i ||
        @land.army2 > @current_armies[4].css("a[href= '#']").text[1...-1].to_i ||
        @land.army3 > @current_armies[8].css("a[href= '#']").text[1...-1].to_i ||
        @land.army4 > @current_armies[1].css("a[href= '#']").text[1...-1].to_i ||
        @land.army5 > @current_armies[5].css("a[href= '#']").text[1...-1].to_i ||
        @land.army6 > @current_armies[9].css("a[href= '#']").text[1...-1].to_i ||
        @land.army7 > @current_armies[2].css("a[href= '#']").text[1...-1].to_i ||
        @land.army8 > @current_armies[6].css("a[href= '#']").text[1...-1].to_i ||
        @land.army9 > @current_armies[3].css("a[href= '#']").text[1...-1].to_i ||
        @land.army10 > @current_armies[7].css("a[href= '#']").text[1...-1].to_i
        puts "het linh"
        false
      else
        @timestamp = page.css("input[name='timestamp'] @value").text
        @timestamp_checksum = page.css("input[name='timestamp_checksum'] @value").text
        @b = page.css("input[name='b'] @value").text
        true
      end
    else
      puts "timeout"
      @b = nil
      true
    end
  end

  def can_farm?
    responses = RestClient.get("https://ts6.travian.com.vn/position_details.php?x=#{@land.coordinate_x}&y=#{@land.coordinate_y}", cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML responses
    sleep 0.1 + rand*0.1

    if page.css(".titleInHeader").text.include? "ốc đảo"
      puts "destroy #{@land.coordinate_x}|#{@land.coordinate_y}"
      @land.destroy
      return false
    end

    first_farm_history = page.css(".instantTabs tr td")[0]

    unless first_farm_history.present?
      return false
    end

    first_farm_history = first_farm_history.css("img")
    unless first_farm_history.present?
      return false
    end
    
    report = first_farm_history.attr("class").to_s.split(" ")[1]

    if report == "iReport3" || report == "iReport2"
      puts "destroy #{@land.coordinate_x}|#{@land.coordinate_y}"
      @land.destroy
      return false
    end

    if report == "iReport1"
      return true
    end
    return false
  end

  def send_request
    @user = User.find_by id: @myvillage.user_id
    if @user.active != @active
      raise 'Stop this turn'  
    end
    unless can_farm? 
      return "skip"
    end

    if check_number_army?
      if !@b.nil?
        sleep 0.1
        # gui request2, vao trang "xac nhan"
        response1 = RestClient.post("https://ts6.travian.com.vn/build.php?id=39&tt=2",
          {timestamp: @timestamp, timestamp_checksum: @timestamp_checksum,
          b: @b, currentDid: @myvillage.link.split(/[^\d]/).join, t1: @land.army1.to_s,
          t2: @land.army2.to_s, t3: @land.army3.to_s, t4: @land.army4.to_s, t5: @land.army5.to_s,
          t6: @land.army6.to_s, t7: @land.army7.to_s, t8: @land.army8.to_s, t9: @land.army9.to_s,
          t10: @land.army10.to_s, t11: @land.army11.to_s, dname: "", x: @land.coordinate_x.to_s,
          y: @land.coordinate_y.to_s, c: "4", s1: "ok"}, cookies: @cookies)
        page = Nokogiri::HTML response1
        if !page.css("table#short_info").empty? #gui request 2 thanh coong
          # gui request "xac nhan"
          response = RestClient.post("https://ts6.travian.com.vn/build.php?id=39&tt=2",
            {redeployHero: page.css("input[name='redeployHero'] @value").text,
            timestamp: page.css("input[name='timestamp'] @value").text,
            timestamp_checksum: page.css("input[name='timestamp_checksum'] @value").text,
            id: page.css("input[name='id'] @value").text,
            a: page.css("input[name='a'] @value").text,
            c: page.css("input[name='c'] @value").text,
            kid: page.css("input[name='kid'] @value").text,
            t1: page.css("input[name='t1'] @value").text,
            t2: page.css("input[name='t2'] @value").text,
            t3: page.css("input[name='t3'] @value").text,
            t4: page.css("input[name='t4'] @value").text,
            t5: page.css("input[name='t5'] @value").text,
            t6: page.css("input[name='t6'] @value").text,
            t7: page.css("input[name='t7'] @value").text,
            t8: page.css("input[name='t8'] @value").text,
            t9: page.css("input[name='t9'] @value").text,
            t10: page.css("input[name='t10'] @value").text,
            t11: page.css("input[name='t11'] @value").text,
            sendReally: page.css("input[name='sendReally'] @value").text,
            troopsSent: page.css("input[name='troopsSent'] @value").text,
            currentDid: page.css("input[name='currentDid'] @value").text,
            b: page.css("input[name='b'] @value").text,
            dname: page.css("input[name='dname'] @value").text,
            x: page.css("input[name='x'] @value").text,
            y: page.css("input[name='y'] @value").text,
            }, cookies: @cookies){|response|
              if [301, 302, 307].include? response.code
              end
            }
          return "true"
        elsif !page.css("p.error").empty? && (page.css("p.error").text == "Không có làng nào ở tọa độ này" ||
          page.css("p.error").text == "Bạn không thể gửi lính tới người chơi khác khi họ đang trong chế độ kỳ nghỉ.")
          @land.update_attributes! my_village_id: nil, user_id: nil
          puts "#{@land.coordinate_x}|#{@land.coordinate_y} vung dat bo hoang"
          @land.destroy
          return "skip"
        elsif !page.css("p.error").empty? && (page.css("p.error").text == "làng của tướng đã được thay đổi." ||
          page.css("p.error").text == "Bạn chưa lựa chọn quân nào cả")
          puts "#{@land.coordinate_x}|#{@land.coordinate_y}: Loi step 1"
          return "skip"
        end
      else
        return "skip"
      end
    else
      return "false"
    end
  end
end
