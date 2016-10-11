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
    (1..3).each do
      response = RestClient.get "http://ts19.travian.com.vn/dorf1.php", cookies: @cookies
      page = Nokogiri::HTML response
      if page.css("div#header ul#navigation").empty?
        puts "Da bi dang xuat"
        sleep 1
        logout_res = RestClient.get "http://ts19.travian.com.vn"
        logout_page = Nokogiri::HTML logout_res
        login = logout_page.css("input[name='login'] @value").text
        sleep 1
        @login_res = RestClient.post "http://ts19.travian.com.vn/dorf1.php",
          {name: user.name, password: user.password,
          s1: "Đăng+nhập", w: "1366:768", login: login, lowRes: "0"}
        login_page = Nokogiri::HTML @login_res
        unless login_page.css("div#header ul#navigation").empty?
          user.update_attributes! t3e: @login_res.cookies["T3E"], sess_id: @login_res.cookies["sess_id"]
          puts "Da dang nhap lai"
          break
        end
      else
        puts "Van dang nhap"
        break
      end
    end
    user.my_villages.each do |my_village|
      puts "#{my_village.name}::#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"
      my_village.farm_for_village @cookies
    end
    puts "___________________________________________________________"
  end
end
# whenever --update-crontab --set environment=development
