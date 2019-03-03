class Hero
  require "rest-client"
  require "nokogiri"

  def initialize cookies
    @cookies = cookies
  end

  def get_dame
    responses = RestClient.get("https://ts6.travian.com.vn/hero.php",
      cookies: {"T3E" => @cookies["T3E"], "lowRes" => "0", "sess_id" => @cookies["sess_id"]})
    sleep 0.25 + rand*0.5
    page = Nokogiri::HTML responses
    if page.css(".heroStatusMessage").text.include? "đang di chuyển"
      return 0
    end
    return page.css("#attributepower span").text[1...-1].to_i
  end
end
