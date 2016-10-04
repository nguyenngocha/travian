class Farms
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, land
    @cookies = cookies
    @myvillage = myvillage
    @land = land
  end

  def check_number_army?
    sleep 1
    # gui request 1, vao trang "gui linh" de check so luong linh
    response = RestClient.get("http://ts19.travian.com.vn/build.php" + @myvillage.link + "id=39&tt=2&gid=16",
      cookies: @cookies)
    page = Nokogiri::HTML(response)
    @current_armies = page.css("table#troops td")
    if @land.army1 > @current_armies[0].css("a[href= '#']").text.to_i ||
      @land.army2 > @current_armies[4].css("a[href= '#']").text.to_i ||
      @land.army3 > @current_armies[8].css("a[href= '#']").text.to_i ||
      @land.army4 > @current_armies[1].css("a[href= '#']").text.to_i ||
      @land.army5 > @current_armies[5].css("a[href= '#']").text.to_i ||
      @land.army6 > @current_armies[9].css("a[href= '#']").text.to_i ||
      @land.army7 > @current_armies[2].css("a[href= '#']").text.to_i ||
      @land.army8 > @current_armies[6].css("a[href= '#']").text.to_i ||
      @land.army9 > @current_armies[3].css("a[href= '#']").text.to_i ||
      @land.army10 > @current_armies[7].css("a[href= '#']").text.to_i
      false
    else
      @timestamp = page.css("input[name='timestamp'] @value").text
      @timestamp_checksum = page.css("input[name='timestamp_checksum'] @value").text
      @b = page.css("input[name='b'] @value").text
      true
    end
  end

  def send_request
    if check_number_army?
      sleep 1
      # gui request2, vao trang "xac nhan"
      response1 = RestClient.post("http://ts19.travian.com.vn/build.php?id=39&tt=2",
        {timestamp: @timestamp, timestamp_checksum: @timestamp_checksum,
        b: @b, currentDid: @myvillage.link.split(/[^\d]/).join, t1: @land.army1.to_s,
        t2: @land.army2.to_s, t3: @land.army3.to_s, t4: @land.army4.to_s, t5: @land.army5.to_s,
        t6: @land.army6.to_s, t7: @land.army7.to_s, t8: @land.army8.to_s, t9: @land.army9.to_s,
        t10: @land.army10.to_s, t11: @land.army11.to_s, dname: "", x: @land.coordinate_x.to_s,
        y: @land.coordinate_y.to_s, c: "4", s1: "ok"}, cookies: @cookies)
      page = Nokogiri::HTML response1

      if !page.css("table#short_info").empty? #gui request 2 thanh coong
        sleep 1
        # gui request "xac nhan"
        response = RestClient.post("http://ts19.travian.com.vn/build.php?id=39&tt=2",
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
      else
        return false
      end
    else
      return false
    end
  end
end
