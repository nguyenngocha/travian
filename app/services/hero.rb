class Hero
  require "rest-client"
  require "nokogiri"

  def initialize cookies, user
    @cookies = cookies
    @user = user
  end

  def get_dame
    responses = RestClient.get("#{@user.server}/hero.php",
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    sleep 0.25 + rand*0.5
    page = Nokogiri::HTML responses
    if page.css(".heroStatusMessage").text.include? "Đến trong vòng"
      return 0
    end
    return page.css("#attributepower span").text[1...-1].to_i
  end
end
