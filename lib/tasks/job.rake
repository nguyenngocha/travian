require "rest-client"
require "nokogiri"

namespace :job do
  desc "TODO"
  task farm_all: :environment do
    user = User.first
    @cookies = Hash.new
    @cookies["T3E"] = user.t3e
    @cookies["lowRes"] = "0"
    @cookies["sess_id"] = user.sess_id
    # check login
    response = RestClient.get "http://ts19.travian.com.vn/dorf1.php", cookies: @cookies
    page = Nokogiri::HTML response
    if page.css("div#header ul#navigation").empty?
      logout_res = RestClient.get "http://ts19.travian.com.vn/logout.php", cookies: @cookies
      logout_page = Nokogiri::HTML logout_res
      login = logout_page.css("input[name='login'] @value").text
      puts "loi dnag nhap"
      @login_res = RestClient.post "http://ts19.travian.com.vn/dorf1.php",
        {name: "hatd", password: "Trandahanh(9",
        s1: "Đăng+nhập", w: "1366:768", login: login, lowRes: "0"}
      if @login_res.cookies
        user.update_attributes! t3e: @login_res.cookies["T3E"], sess_id: @login_res.cookies["sess_id"]
      end
    end
    login_page = Nokogiri::HTML @login_res
    if page.css("div#header ul#navigation").empty?
      puts "dang nhap loi"
    else
      MyVillage.all.each do |my_village|
        puts "#{my_village.name}-#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
        my_village.farm_for_village @cookies
      end
      puts "___________________________________________________________"
    end
  end
end
# whenever --update-crontab --set environment=development
