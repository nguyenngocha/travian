class RandomUpgrateOutDorf
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active
    @cookies = cookies
    @myvillage = myvillage
    @active = active
  end

  def send_request
    print "Outer: "
    @user = User.find_by id: @myvillage.user_id
    response = RestClient.get "#{@user.server}/dorf1.php#{@myvillage.link}", cookies: @cookies
    page = Nokogiri::HTML response
    sleep 1

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

    (0...17).each do |i|
      if builds[i].attr("class").to_s.include?("good")&& !builds[i].attr("class").to_s.include?("gid4")
        can_upgrate_buildings << i+1
      end
    end

    if can_upgrate_buildings.empty?
      return nil
    end
    return can_upgrate_buildings.sample
  end
end
