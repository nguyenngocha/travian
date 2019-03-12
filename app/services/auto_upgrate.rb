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

    sleep 0.25
    response = RestClient.get "#{@user.server}/#{@link_id}", cookies: @cookies
    response = Nokogiri::HTML response
    link = response.css("#content #build button").first.attr("onclick")
    link = link.match(/'([^']+)'/)[1] if link.present?
    if link.present?
      link = "#{@user.server}/" + link
      response = RestClient.get link, cookies: @cookies
      puts "success"
      return true
    else
      puts "resource exhausted"
      return false
    end
  end
end
