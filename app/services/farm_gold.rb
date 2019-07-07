class FarmGold
  require "rest-client"
  require "nokogiri"

  def initialize cookies, user
    @cookies = cookies
    @user = user
  end

  def execute
    @headers = {
      cookies: @cookies,
      "referer": "#{@user.server}/dorf1.php",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
    }
    response = RestClient.get "#{@user.server}/build.php?gid=16&tt=99", @headers
    page = Nokogiri::HTML response
    sleep 1

    farm_lists = Array.new
    page.css("#raidList > .listEntry").each_with_index do |farm_list, index|
      farm_lists << index
    end
    
    farm_lists.shuffle.each do |index|
      puts index
      send_request index
    end
  end

  def send_request index
    @headers = {
      cookies: @cookies,
      "referer": "#{@user.server}/build.php?gid=16&tt=99",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
    }
    response = RestClient.get "#{@user.server}/build.php?gid=16&tt=99", @headers
    page = Nokogiri::HTML response
    sleep 1

    farm_list = page.css("#raidList > .listEntry")[index]

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
    puts farm_list.css(".listTitleText").text

    slot_rows = farm_list.css(".slotRow")
    slot_rows.each do |slot_row|
      if slot_row.css(".village > a").text.downcase.include? "natars"
        farm_id = slot_row.css("input").attr("name").text
        params[farm_id] = "on"
        next
      end
      report = slot_row.css(".lastRaid img")[0]
      next unless report.present?
      report = report.attr("class").split[1]
      next unless report == "iReport1"
      farm_id = slot_row.css("input").attr("name").text
      params[farm_id] = "on"
    end

    @headers = {
      cookies: @cookies,
      "referer": "#{@user.server}/build.php?gid=16&tt=99",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
    }
    puts "RestClient.post(#{@user.server}/build.php?gid=16&tt=99, #{params}, cookies: #{@cookies})"
    RestClient.post("#{@user.server}/build.php?gid=16&tt=99", params, @headers)
    sleep 1
  end
end
