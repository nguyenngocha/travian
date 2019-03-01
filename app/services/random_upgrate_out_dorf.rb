class RandomUpgrateOutDorf
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active
    @cookies = cookies
    @myvillage = myvillage
    @active = active
  end

  def send_request
    @user = User.find_by id: @myvillage.user_id

    if can_upgrate?
      # chen them code upgrate uu tien vao day.
      flag = nil
      # neu upgrate uu tien rong thi auto upgrate.
      if @myvillage.upgrate_schedules.present?
        upgrate = @myvillage.upgrate_schedules.first
        link_id = upgrate.upgrate_id if upgrate
        link_id = "build.php#{@myvillage.link}id=#{link_id}"
        flag = upgrate
      else
        link_id = get_id_building_enough_resource
        link_id = "build.php#{@myvillage.link}id=#{link_id}"
      end

      puts link_id
      if link_id.nil?
        puts "full-all"
      else
        #neu upgrate thanh cong se destroy lich upgrate
        if AutoUpgrate.new(@cookies, @myvillage, @active, link_id).send_request
          UpgrateSchedule.destroy flag if flag
          #neu thieu tai nguyen se lam gi?
        end
      end
    else
      puts "upgrating"
    end
  end

  private
  def can_upgrate?
    response = RestClient.get "https://ts6.travian.com.vn/dorf1.php#{@myvillage.link}", cookies: @cookies
    response = Nokogiri::HTML response
    if response.css(".boxes-contents .buildDuration span").present?
      return false
    end
    return true
  end

  def get_id_building_enough_resource
    response = RestClient.get "https://ts6.travian.com.vn/dorf1.php#{@myvillage.link}", cookies: @cookies
    response = Nokogiri::HTML response
    can_upgrate_buildings = Array.new
    builds = response.css("#village_map div.level")

puts builds
    (0...17).each do |i|
      if builds[i].attr("class").to_s.include? "good"
        can_upgrate_buildings << i+1
      end
    end
    return can_upgrate_buildings.sample
  end
end
