class FarmOasis
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, oasise, active
    @cookies = cookies
    @myvillage = myvillage
    @oasise = oasise
    @active = active
  end

  def oasis_clean?
    responses = RestClient.get("https://ts6.travian.com.vn/position_details.php?x=#{@oasise.coordinate_x}&y=#{@oasise.coordinate_y}",
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML responses

    puts page.css("#troop_info")[0].text.include? "không có"
    return page.css("#troop_info")[0].text.include? "không có"
  end


  def check_number_army?
    response = RestClient.get("https://ts6.travian.com.vn/build.php" + @myvillage.link + "id=39&tt=2&gid=16",
      cookies: @cookies)
    page = Nokogiri::HTML response
    if page.css("div#header ul#navigation").empty? #kiem tra tinh trang dang nhap
      puts "Da bi dang xuat(farm.rb)"
      puts "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"
      sleep 1
      logout_res = RestClient.get "https://ts6.travian.com.vn"
      logout_page = Nokogiri::HTML logout_res
      login = logout_page.css("input[name='login'] @value").text
      sleep 1
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
      puts @current_armies
      if @oasise.army1 > @current_armies[0].css("a[href= '#']").text.to_i ||
        @oasise.army2 > @current_armies[4].css("a[href= '#']").text.to_i ||
        @oasise.army3 > @current_armies[8].css("a[href= '#']").text.to_i ||
        @oasise.army4 > @current_armies[1].css("a[href= '#']").text.to_i ||
        @oasise.army5 > @current_armies[5].css("a[href= '#']").text.to_i ||
        @oasise.army6 > @current_armies[9].css("a[href= '#']").text.to_i ||
        @oasise.army7 > @current_armies[2].css("a[href= '#']").text.to_i ||
        @oasise.army8 > @current_armies[6].css("a[href= '#']").text.to_i ||
        @oasise.army9 > @current_armies[3].css("a[href= '#']").text.to_i ||
        @oasise.army10 > @current_armies[7].css("a[href= '#']").text.to_i
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

  def send_request
    @user = User.find_by id: @myvillage.user_id
    if @user.active != @active
      puts "Stop this turn"
      return false
    end

    unless oasis_clean?
      return true
    end

    if check_number_army?
      if !@b.nil?
        sleep 1
        # gui request2, vao trang "xac nhan"
        response1 = RestClient.post("https://ts6.travian.com.vn/build.php?id=39&tt=2",
          {timestamp: @timestamp, timestamp_checksum: @timestamp_checksum,
          b: @b, currentDid: @myvillage.link.split(/[^\d]/).join, t1: @oasise.army1.to_s,
          t2: @oasise.army2.to_s, t3: @oasise.army3.to_s, t4: @oasise.army4.to_s, t5: @oasise.army5.to_s,
          t6: @oasise.army6.to_s, t7: @oasise.army7.to_s, t8: @oasise.army8.to_s, t9: @oasise.army9.to_s,
          t10: @oasise.army10.to_s, t11: @oasise.army11.to_s, dname: "", x: @oasise.coordinate_x.to_s,
          y: @oasise.coordinate_y.to_s, c: "4", s1: "ok"}, cookies: @cookies)
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
          return true
        elsif !page.css("p.error").empty? && (page.css("p.error").text == "Không có làng nào ở tọa độ này" ||
          page.css("p.error").text == "Bạn không thể gửi lính tới người chơi khác khi họ đang trong chế độ kỳ nghỉ.")
          @oasise.update_attributes! my_village_id: nil, user_id: nil
          puts "#{@oasise.coordinate_x}|#{@oasise.coordinate_y} vung dat bo hoang"
          return true
        elsif !page.css("p.error").empty? && (page.css("p.error").text == "làng của tướng đã được thay đổi." ||
          page.css("p.error").text == "Bạn chưa lựa chọn quân nào cả")
          puts "#{@oasise.coordinate_x}|#{@oasise.coordinate_y}: Loi step 1"
          return true
        end
      else
        return true
      end
    else
      return false
    end
  end
end
