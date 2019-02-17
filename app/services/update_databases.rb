class UpdateDatabases
  require "nokogiri"
  require "rest-client"

  def initialize page, cookies
    @page = page
    @cookies = cookies
  end

  def check_login? dorf1
    dorf1.css("div#header ul#navigation").empty?
  end

  def create_resource href, myvillage
    response = RestClient.get("https://ts6.travian.com.vn/dorf1.php" + href.value,
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML(response)
    return false if check_login? page
  end

  def update_my_village myvillage, dorf1, href
    x_text = dorf1.css("a[href = '#{href.value}'] span.coordinateX").text
    y_text = dorf1.css("a[href = '#{href.value}'] span.coordinateY").text

    x = (x_text.include? "−") ? -x_text.split(/[^\d]/).join.to_i : x_text.split(/[^\d]/).join.to_i
    y = (y_text.include? "−") ? -y_text.split(/[^\d]/).join.to_i : y_text.split(/[^\d]/).join.to_i

    myvillage.update! name: dorf1.css("div#villageNameField").text, link: href.value,
      coordinate_x: x,
      coordinate_y: y,
      wood: dorf1.css("li#stockBarResource1 span#l1").text.to_i,
      clay: dorf1.css("li#stockBarResource2 span#l2").text.to_i,
      iron: dorf1.css("li#stockBarResource3 span#l3").text.to_i,
      max_warehouse: dorf1.css("span#stockBarWarehouse").text.to_i,
      crop: dorf1.css("li#stockBarResource4 span#l4").text.to_i,
      max_granary: dorf1.css("span#stockBarGranary").text.to_i,
      wood_quanity: dorf1.css("table#production td.num")[0].text.split(/[^\d]/).join.to_i,
      clay_quanity: dorf1.css("table#production td.num")[1].text.split(/[^\d]/).join.to_i,
      iron_quanity: dorf1.css("table#production td.num")[2].text.split(/[^\d]/).join.to_i,
      crop_quanity: dorf1.css("table#production td.num")[3].text.split(/[^\d]/).join.to_i

  end

  def create_my_village dorf1, user, href
    x_text = dorf1.css("a[href = '#{href.value}'] span.coordinateX").text
    y_text = dorf1.css("a[href = '#{href.value}'] span.coordinateY").text

    x = (x_text.include? "−") ? -x_text.split(/[^\d]/).join.to_i : x_text.split(/[^\d]/).join.to_i
    y = (y_text.include? "−") ? -y_text.split(/[^\d]/).join.to_i : y_text.split(/[^\d]/).join.to_i

    myvillage = user.my_villages.create! name: dorf1.css("div#villageNameField").text, link: href.value,
      coordinate_x: x,
      coordinate_y: y,
      wood: dorf1.css("li#stockBarResource1 span#l1").text.to_i,
      clay: dorf1.css("li#stockBarResource2 span#l2").text.to_i,
      iron: dorf1.css("li#stockBarResource3 span#l3").text.to_i,
      max_warehouse: dorf1.css("span#stockBarWarehouse").text.to_i,
      crop: dorf1.css("li#stockBarResource4 span#l4").text.to_i,
      max_granary: dorf1.css("span#stockBarGranary").text.to_i,
      wood_quanity: dorf1.css("table#production td.num")[0].text.split(/[^\d]/).join.to_i,
      clay_quanity: dorf1.css("table#production td.num")[1].text.split(/[^\d]/).join.to_i,
      iron_quanity: dorf1.css("table#production td.num")[2].text.split(/[^\d]/).join.to_i,
      crop_quanity: dorf1.css("table#production td.num")[3].text.split(/[^\d]/).join.to_i

  end

  def load_my_village user
    hrefs = @page.css("div.innerBox.content ul li a @href")
    hrefs.each do |href|
      if href.value.starts_with? "?newdid"
        sleep 1
        response = RestClient.get("https://ts6.travian.com.vn/dorf1.php" + href.value,
          cookies: {"T3E" => user.t3e, "lowRes" => "0", "sess_id" => user.sess_id})
        @dorf1 = Nokogiri::HTML response

        return false if check_login? @dorf1 #keim tra xem con dang login khong

        myvillage = MyVillage.find_by link: href.value
        if myvillage #neu co myvillage thi update
          update_my_village myvillage, @dorf1, href
        else #tao my_village moi
          create_my_village @dorf1, user, href
        end
      end
    end
  end

  def load_user name, password, race
    user = User.find_by name: name
    if user
      load_my_village user
      # update thong tin
    else
      user = User.create! name: name, password: password, race: race, t3e: @cookies["T3E"], sess_id: @cookies["sess_id"]
      load_my_village user
      # tao moi 1 user
    end
  end
end
