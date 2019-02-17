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

    link = "https://ts6.travian.com.vn/build.php?id=#{@troop_schedule.build_id}"
    response = RestClient.get link, cookies: @cookies
    response = Nokogiri::HTML response
    trainUnits = response.css(".trainUnits .details a[href= '#']")[2].text.split(/[^\d]/).join.to_i
    puts trainUnits

    if @troop_schedule.troop_number > trainUnits
      return false
    end

    puts response.css(".trainUnits input")
    # response = RestClient.post(link, {id: @troop_schedule.build_id, a: 2, s: 1,
    #   "t1": @troop_schedule.troop_number, s1: "ok"}, @cookies)

    puts response
    page = Nokogiri::HTML response
  end
end