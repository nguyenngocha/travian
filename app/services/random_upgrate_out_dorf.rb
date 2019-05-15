class RandomUpgrateOutDorf
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active
    @cookies = cookies
    @myvillage = myvillage
    @active = active
    @user = myvillage.user
  end

  def send_request

    print "Outer: "
    @headers = {
        cookies: @cookies,
        "referer": "#{@user.server}",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
      }

    response = RestClient.get("#{@user.server}/dorf1.php#{@myvillage.link}", @headers) 
    page = Nokogiri::HTML response

    time = page.css(".buildingList .buildDuration span").first
    if time.nil?
      @wait_time = 0
    else
      time = time.text.split(":")
      @wait_time = time[0].to_i*60 + time[1].to_i
    end

    @myvillage.update_attributes wait_time: @wait_time

    # chen them code upgrate uu tien vao day.
    flag = nil
    # neu upgrate uu tien rong thi auto upgrate.
    if @myvillage.update_outer_list.present?
      upgrate = @myvillage.update_outer_list.first

      flag = upgrate
      if can_upgrate? page, upgrate.upgrate_id
        link_id = upgrate.upgrate_id
      end
    else
      if(!@myvillage.upcrop && !@myvillage.upresource)
        puts "khong tu upgrate ngoai thanh"
        return
      end
      link_id = get_id_building_enough_resource page
    end

    if link_id.nil?
      puts "Dang update hoac khong du tai nguyen"
    else
      link_id = "build.php#{@myvillage.link}id=#{link_id}"
      #neu upgrate thanh cong se destroy lich upgrate
      if AutoUpgrate.new(@cookies, @myvillage, @active, link_id).send_request
        UpgrateSchedule.destroy flag if flag
        #neu thieu tai nguyen se lam gi?
      end
    end
  end

  private
  def can_upgrate? page, id
    builds = page.css("#village_map div.level")
    if builds[id-1].attr("class").to_s.include? "good"
      return true
    else
      return false
    end
  end

  def get_id_building_enough_resource page
    can_upgrate_buildings = Array.new
    builds = page.css("#village_map div.level")

    if @myvillage.upresource
      (0...17).each do |i|
        if builds[i].attr("class").to_s.include?("good") && !builds[i].attr("class").to_s.include?("gid4")
          can_upgrate_buildings << i+1
        end
      end
    end

    if @myvillage.upcrop
      if can_upgrate_buildings.empty?
        (0...17).each do |i|
          if builds[i].attr("class").to_s.include?("good") && builds[i].attr("class").to_s.include?("gid4")
            can_upgrate_buildings << i+1
          end
        end
      end
    end

    if can_upgrate_buildings.empty?
      return nil
    end
    return can_upgrate_buildings.sample
  end
end
