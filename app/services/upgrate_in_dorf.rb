class UpgrateInDorf
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active
    @cookies = cookies
    @myvillage = myvillage
    @active = active
    @user = myvillage.user
  end

  def send_request
    print "Inner: "
    
    if @myvillage.update_inner_list.present?

      @headers = {
        cookies: @cookies,
        accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "ja,en-US;q=0.9,en;q=0.8",
        "referer": "#{@user.server}",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
      }
      response = RestClient.get "#{@user.server}/dorf2.php#{@myvillage.link}", @headers
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