class FarmGold
  require "rest-client"
  require "nokogiri"

  def initialize cookies, user
    @cookies = cookies
    @user = user
  end

  def execute
    response = RestClient.get "#{@user.server}/build.php?gid=16&tt=99", cookies: @cookies
    page = Nokogiri::HTML response

    farm_lists = Array.new
    page.css("#raidList > .listEntry").each do |farm_list|
      farm_lists << farm_list
    end
    
    farm_lists.shuffle.each do |farm_list|
      send_request farm_list
    end
  end
  
  def send_request farm_list
    @action = farm_list.css("input[name='action']").attr("value").text
    @a = farm_list.css("input[name='a']").attr("value").text
    @sort = farm_list.css("input[name='sort']").attr("value").text
    @direction = farm_list.css("input[name='direction']").attr("value").text
    @lid = farm_list.css("input[name='lid']").attr("value").text

    params = {}
    params[:action] = @action
    params[:a] = @a
    params[:sort] = @sort
    params[:direction] = @direction
    params[:lid] = @lid

    slot_rows = farm_list.css(".slotRow")
    slot_rows.each do |slot_row|
      report = slot_row.css(".lastRaid img")[0]
      next unless report.present?
      report = report.attr("class").split[1]
      next unless report == "iReport1"
      farm_id = slot_row.css("input").attr("name").text
      params[farm_id] = "on"
    end

    RestClient.post("#{@user.server}/build.php?gid=16&tt=99", params, cookies: @cookies)
    sleep 1
  end
end