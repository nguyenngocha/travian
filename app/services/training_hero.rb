class TrainingHero
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, oasise, active, hero_dame
    @cookies = cookies
    @myvillage = myvillage
    @oasise = oasise
    @active = active
    @hero_dame = hero_dame
  end

  def oasis_clean?
    responses = RestClient.get("https://ts6.travian.com.vn/position_details.php?x=#{@oasise.coordinate_x}&y=#{@oasise.coordinate_y}",
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    sleep 0.25 + rand*0.5
    page = Nokogiri::HTML responses

    if page.css(".titleInHeader").text.downcase.include? "đã bị chiếm"
      puts "da bi chiem #{@oasise.coordinate_x}|#{@oasise.coordinate_y}"
      @land.destroy
      return false
    end

    troops = page.css("#troop_info")[0].css("tr")
    unless troops.present?
      return false
    end

    target_def = 0
    troops.each do |troop|
      s = troop.css(".ico img")
      if s.present?
        puts troop.css(".val").text[1...-1] + " " + s.attr("alt").text
        target_def += caculate_dame s.attr("class").text.split[1], troop.css(".val").text[1...-1].to_i
      end
    end
    puts target_def
    puts @hero_dame
    if @hero_dame/15 < target_def and target_def < @hero_dame/5
      puts "true"
      return true
    end
    puts "false"
    return false
  end

  def caculate_dame unit, number
    if unit == "u31"
      return number*20
    elsif unit == "u32"
      return number*40
    elsif unit == "u33"
      return number*60
    elsif unit == "u35"
      return number*33
    elsif unit == "u34"
      return number*50
    elsif unit == "u36"
      return number*70
    elsif unit == "u37"
      return number*200*100
    elsif unit == "u38"
      return number*240*100
    elsif unit == "u39"
      return number*250*100
    else 
      return number*520*100
    end
  end

  def check_number_army?
    response = RestClient.get("https://ts6.travian.com.vn/build.php" + @myvillage.link + "id=39&tt=2&gid=16",
      cookies: @cookies)
    sleep 0.25 + rand*0.5

    page = Nokogiri::HTML response
    if page.css("div#header ul#navigation").empty? #kiem tra tinh trang dang nhap
      puts "Da bi dang xuat(farm.rb)"
      puts "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"
      logout_res = RestClient.get "https://ts6.travian.com.vn"
      sleep 1

      logout_page = Nokogiri::HTML logout_res
      login = logout_page.css("input[name='login'] @value").text
      @login_res = RestClient.post "https://ts6.travian.com.vn/dorf1.php",
        {name: @myvillage.user.name, password: @myvillage.user.password,
        s1: "Đăng+nhập", w: "1366:768", login: login, lowRes: "0"}
      sleep 1

      login_page = Nokogiri::HTML @login_res
      unless login_page.css("div#header ul#navigation").empty?
        @myvillage.user.update_attributes! t3e: @login_res.cookies["T3E"], sess_id: @login_res.cookies["sess_id"]
        puts "Da dang nhap lai(farm.rb)"
      end
    end

    @current_armies = page.css("table#troops td")
    unless @current_armies[11].text.present?
      puts "tuong khong co trong thanh"
      return false
    end

    if !@current_armies.empty?
      if @oasise.army1 > @current_armies[0].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army2 > @current_armies[4].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army3 > @current_armies[8].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army4 > @current_armies[1].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army5 > @current_armies[5].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army6 > @current_armies[9].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army7 > @current_armies[2].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army8 > @current_armies[6].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army9 > @current_armies[3].css("a[href= '#']").text[1...-1].to_i ||
        @oasise.army10 > @current_armies[7].css("a[href= '#']").text[1...-1].to_i
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
      puts "skip"
      return true
    end

    if check_number_army?
      if !@b.nil?
        # gui request2, vao trang "xac nhan"
        response1 = RestClient.post("https://ts6.travian.com.vn/build.php?id=39&tt=2",
          {timestamp: @timestamp, timestamp_checksum: @timestamp_checksum,
          b: @b, currentDid: @myvillage.link.split(/[^\d]/).join, t1: @oasise.army1.to_s,
          t2: @oasise.army2.to_s, t3: @oasise.army3.to_s, t4: @oasise.army4.to_s, t5: @oasise.army5.to_s,
          t6: @oasise.army6.to_s, t7: @oasise.army7.to_s, t8: @oasise.army8.to_s, t9: @oasise.army9.to_s,
          t10: @oasise.army10.to_s, t11: 1, dname: "", x: @oasise.coordinate_x.to_s,
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
            puts "ok"
          return false
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
        return false
      end
    else
      return false
    end
  end
end
