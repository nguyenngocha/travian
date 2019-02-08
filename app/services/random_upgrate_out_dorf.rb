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
    if @user.active != @active
      puts "Stop this turn"
      return false
    end

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
        myvillage = @myvillage.link
        myvillage.slice!(0)
        link_id = link_id.insert(10, myvillage) if link_id
      end

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
    puts response.css(".boxes-contents .buildDuration span")
    if response.css(".boxes-contents .buildDuration span").present?
      return false
    end
    return true
  end

  def get_id_building_enough_resource
    response = RestClient.get "https://ts6.travian.com.vn/dorf1.php#{@myvillage.link}", cookies: @cookies
    response = Nokogiri::HTML response
    can_upgrate_buildings = Array.new
    response.css("#content area").each do |area|
      title = area.attr("title")
      title = Nokogiri::HTML title
      if title.css(".showCosts").present?
        can_upgrate_buildings << area.attr("href").to_s
      end
    end
    return can_upgrate_buildings.sample
  end
end
