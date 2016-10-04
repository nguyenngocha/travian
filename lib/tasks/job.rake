require "rest-client"
require "nokogiri"

namespace :job do
  desc "TODO"
  task farm_all: :environment do
    response = RestClient.post "http://ts19.travian.com.vn/dorf1.php",
      {name: "hatd", password: "Trandahanh(9",
      s1: "Đăng+nhập", w: "1366:768", login: "1475511974", lowRes: "0"}
    page= Nokogiri::HTML response
    if page.css("div#header ul#navigation").empty?
      puts "dang nhap loi"
    else
      MyVillage.all.each do |my_village|
        puts "#{my_village.name}-#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
        my_village.farm_for_village response.cookies
      end
      puts "___________________________________________________________"
    end
  end
end
# whenever --update-crontab --set environment=development
