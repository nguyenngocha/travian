class UpgrateInDorf
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active
    @cookies = cookies
    @myvillage = myvillage
    @active = active
  end

  def send_request
    print "Inner: "
    
    if @myvillage.update_inner_list.present?
      
      @user = User.find_by id: @myvillage.user_id
      response = RestClient.get "#{@user.server}/dorf2.php#{@myvillage.link}", cookies: @cookies
      page = Nokogiri::HTML response
      sleep 1

      if can_upgrate? page, @myvillage.update_inner_list.first.upgrate_id
        link_id = "build.php#{@myvillage.link}id=#{@myvillage.update_inner_list.first.upgrate_id}"
        if AutoUpgrate.new(@cookies, @myvillage, @user.active, link_id).send_request
          UpgrateSchedule.destroy @myvillage.update_inner_list.first
          puts "success"
        end
      else
        puts "Dang update hoac thieu tai nguyen"
      end
    end
  end
  
  private
  def can_upgrate? page, id
    builds = page.css(".villageMapWrapper #village_map div.buildingSlot")
    if builds[id-1].css("div.level").attr("class").to_s.include? "good"
      return true
    else
      return false
    end
    return false
  end

end