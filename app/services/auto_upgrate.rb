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

    @headers = {
        cookies: @cookies,
        accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "ja,en-US;q=0.9,en;q=0.8",
        "referer": "#{@user.server}/dorf1.php",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
      }
    response = RestClient.get "#{@user.server}/#{@link_id}", @headers
    page = Nokogiri::HTML response
    sleep 0.25
    link = page.css("#content #build button").first.attr("onclick")
    link = link.match(/'([^']+)'/)[1] if link.present?
    if link.present?
      link = "#{@user.server}/" + link
      @headers = {
        cookies: @cookies,
        accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "ja,en-US;q=0.9,en;q=0.8",
        "referer": "#{@user.server}/#{@link_id}",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
      }
      response = RestClient.get link, @headers
      puts "success"
      return true
    else
      puts "resource exhausted"
      return false
    end
  end
end
