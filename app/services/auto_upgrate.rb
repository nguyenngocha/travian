class AutoUpgrate
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active, link_id
    @cookies = cookies
    @myvillage = myvillage
    @active = active
    @link_id = link_id
  end

  def send_request
    @user = User.find_by id: @myvillage.user_id
    if @user.active != @active
      puts "Stop this turn"
      return false
    end

    response = RestClient.get "http://ts19.travian.com.vn/#{@link_id}", cookies: @cookies
    response = Nokogiri::HTML response
    link = response.css("#content #build button").first
    link = link.attr("onclick").match(/'([^']+)'/)[1] unless link.nil?
    if link == "disabled"
      puts "resource exhausted"
      return false
    else
      link = "http://ts19.travian.com.vn/" + link
      response = RestClient.get link, cookies: @cookies
      puts "success"
      return true
    end
  end
end
