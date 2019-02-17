class CreateTroop
  require "rest-client"
  require "nokogiri"

  def initialize cookies, myvillage, active, troop_schedule
    @cookies = cookies
    @myvillage = myvillage
    @active = active
    @troop_schedule = troop_schedule
  end
  
  def execute
    @user = User.find_by id: @myvillage.user_id
    if @user.active != @active
      puts "Stop this turn"
      return false
    end

    if @troop_schedule.troop_id < 3
      gid = 19
    elsif @troop_schedule.troop_id < 7
      gid = 20
    end

    link = "https://ts6.travian.com.vn/build.php#{@myvillage.link}&id=#{@troop_schedule.build_id}&gid=#{gid}"
    puts link
    response = RestClient.get link, cookies: @cookies
    response = Nokogiri::HTML response
    trainUnits = response.css(".trainUnits .details a[href= '#']")[2].text.split(/[^\d]/).join.to_i

    puts trainUnits
    if @troop_schedule.troop_number > trainUnits
      return false
    end

    link = "https://ts6.travian.com.vn/build.php?id=#{@troop_schedule.build_id}"
    puts link
    z_value = response.at("form input[name=z]")["value"]
    response = RestClient.post(link, {id: @troop_schedule.build_id.to_s, a: "2", s: "1", z: z_value, "t#{@troop_schedule.troop_id.to_s}": @troop_schedule.troop_number.to_s, s1: "ok"}, cookies: @cookies)

    TroopSchedule.delete @troop_schedule if @troop_schedule
  end
end