class UpdateDatabases
  require 'nokogiri'
  require "rest-client"

  def initialize page, cookies
    @page = page
    @cookies = cookies
  end

  def check_login? dorf1
    dorf1.css("div#header ul#navigation").empty?
  end

  def load_data page
    hash = {army1: 0, army2: 0, army3: 0, army4: 0, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0}
    armys = page.css("table[class = 'troop_details']")[0].css("td.unit")
    x = 1
    armys.each do |army|
      hash[("army" + x.to_s).to_sym] = army.text.split(/[^\d]/).join.to_i
      x = x + 1
    end
    return hash
  end

  def create_resource href, myvillage
    response = RestClient.get("http://ts19.travian.com.vn/dorf1.php" + href.value,
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML(response)
    return false if check_login? page
  end

  def update_my_village myvillage, dorf1, href
    myvillage.update! name: dorf1.css("div#villageNameField").text, link: href.value,
      coordinate_x: dorf1.css("a[href = '#{href.value}'] span.coordinateX").text.split(/[^\d, -]/).join.to_i,
      coordinate_y: dorf1.css("a[href = '#{href.value}'] span.coordinateY").text.split(/[^\d, -]/).join.to_i,
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

    # update army
    response = RestClient.get("http://ts19.travian.com.vn/build.php?id=39&tt=1" + href.value,
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    page = Nokogiri::HTML(response)
    return false if check_login? page #keim tra xem con dang login khong

    army = Army.find_by my_village_id: myvillage.id
    army.update!(load_data page)

    # update resource
    resources = dorf1.css("div#village_map div.level") # 18 mo
    links = dorf1.css("map[name='rx'] area") #18 link
    (0..17).each do |n|
      array = resources[n].attr("class").split
      @upgrade = true
      @gid = 0
      array.each do |a|
        @gid = a.split(/[^\d]/).join.to_i if a.starts_with? "gid"
        @upgrade = false if a.eql? "notNow"
      end
      @link = links[n].attr("href")
      @level = resources[n].text.split(/[^\d]/).join.to_i
      resource = Resource.find_by my_village_id: myvillage.id, link: @link
      if resource
        resource.update! gid: @gid, level: @level, upgrade: @upgrade, link: @link
      else
        myvillage.resources.create! gid: @gid, level: @level, upgrade: @upgrade, link: @link
      end
    end
    #het resource ngoai thanh
    response = RestClient.get("http://ts19.travian.com.vn/dorf2.php" + href.value,
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    dorf2 = Nokogiri::HTML(response)
    return false if check_login? dorf2 #keim tra xem con dang login khong

    resources = dorf2.css("div#village_map div#levels div.colorLayer")
    gids = dorf2.css("div#village_map img")

    resources.each do |resource|
      array = resource.attr("class").split
      id = resource.attr("class").split(/[^\d]/).join
      @level = resource.text.to_i
      @link = "build.php?id=" + id
      @gid = gids[id.to_i - 19].attr("class").split(/[^\d]/).join.to_i
      @upgrade = true
      array.each do |a|
        @upgrade = false if a.eql? "notNow"
      end
      resource = Resource.find_by my_village_id: myvillage.id, link: @link
      if resource
        resource.update! gid: @gid, level: @level, upgrade: @upgrade, link: @link
      else
        myvillage.resources.create! gid: @gid, level: @level, upgrade: @upgrade, link: @link
      end
    end

  end

  def create_my_village dorf1, user, href
    myvillage = user.my_villages.create! name: dorf1.css("div#villageNameField").text, link: href.value,
      coordinate_x: dorf1.css("a[href = '#{href.value}'] span.coordinateX").text.split(/[^\d, -]/).join.to_i,
      coordinate_y: dorf1.css("a[href = '#{href.value}'] span.coordinateY").text.split(/[^\d, -]/).join.to_i,
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

    if myvillage

      # tao army
      response = RestClient.get("http://ts19.travian.com.vn/build.php?id=39&tt=1" + href.value,
        cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
      page = Nokogiri::HTML(response)
      return false if check_login? page #keim tra xem con dang login khong

      myvillage.armies.create!(load_data page) unless Army.find_by my_village_id: myvillage.id

      # tao resource
      resources = dorf1.css("div#village_map div.level") # 18 mo
      links = dorf1.css("map[name='rx'] area") #18 link
      (0..17).each do |n|
        array = resources[n].attr("class").split
        @upgrade = true
        @gid = 0
        array.each do |a|
          @gid = a.split(/[^\d]/).join.to_i if a.starts_with? "gid"
          @upgrade = false if a.eql? "notNow"
        end
        @link = links[n].attr("href")
        @level = resources[n].text.split(/[^\d]/).join.to_i
        myvillage.resources.create! gid: @gid, level: @level, upgrade: @upgrade, link: @link
      end

      #load het resource ngoai thanh
      response = RestClient.get("http://ts19.travian.com.vn/dorf2.php" + href.value,
        cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
      dorf2 = Nokogiri::HTML(response)
      return false if check_login? dorf2 #keim tra xem con dang login khong

      resources = dorf2.css("div#village_map div#levels div.colorLayer")
      gids = dorf2.css("div#village_map img")

      resources.each do |resource|
        array = resource.attr("class").split
        id = resource.attr("class").split(/[^\d]/).join
        @level = resource.text.to_i
        @link = "build.php?id=" + id
        @gid = gids[id.to_i - 19].attr("class").split(/[^\d]/).join.to_i
        @upgrade = true
        array.each do |a|
          @upgrade = false if a.eql? "notNow"
        end
        myvillage.resources.create! gid: @gid, level: @level, upgrade: @upgrade, link: @link
      end
    end
  end

  def load_my_village user
    hrefs = @page.css("div.innerBox.content ul li a @href")
    hrefs.each do |href|
      if href.value.starts_with? "?newdid"
        sleep 1
        response = RestClient.get("http://ts19.travian.com.vn/dorf1.php" + href.value,
          cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
        @dorf1 = Nokogiri::HTML(response)
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
      user = User.create! name: name, password: password, race: race
      load_my_village user
      # tao moi 1 user
    end
  end
end
