class CreateTroop
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active, troop_schedule
    @cookies = cookies
    @myvillage = myvillage
    @active = active
    @troop_schedule = troop_schedule
    @user = myvillage.user
  end
  
  def execute

    if @user.race == "gauls"
      max_bb = 2
    elsif @user.race == "romans"
      max_bb = 3
    elsif @user.race == "teutons"
      max_bb = 4
    end
  
    if @troop_schedule.troop_id <= max_bb
      gid = 19
    elsif @troop_schedule.troop_id <= 6
      gid = 20
    else
      puts "khong ho tro de quan khac"
      return false
    end

    link = "#{@user.server}/build.php#{@myvillage.link}&id=#{@troop_schedule.build_id}&gid=#{gid}"
    puts link
    @headers = {
      cookies: @cookies,
      "referer": "#{@user.server}/dorf1.php",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
    }
    response = RestClient.get link, @headers
    response = Nokogiri::HTML response
    trainUnits = response.css(".trainUnits .troop#{@troop_schedule.troop_id} .details a[href= '#']")[2].text.split(/[^\d]/).join.to_i

    puts trainUnits
    if @troop_schedule.troop_number > trainUnits
      puts "khong du tai nguyen"
      return false
    end

    @headers = {
      cookies: @cookies,
      "referer": link,
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
    }

    z_value = response.at("form input[name=z]")["value"]
    @param = {
      id: @troop_schedule.build_id.to_s,
      a: "2",
      s: "1",
      z: z_value,
      "t#{@troop_schedule.troop_id.to_s}": @troop_schedule.troop_number.to_s,
      s1: "ok"
    }

    link = "#{@user.server}/build.php?id=#{@troop_schedule.build_id}"
    response = RestClient.post link, @param, @headers
  end
end