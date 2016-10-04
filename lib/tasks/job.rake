require "rest-client"

namespace :job do
  desc "TODO"
  task farm_all: :environment do
    response = RestClient.post "http://ts19.travian.com.vn/dorf1.php",
      {name: "hatd", password: "Trandahanh(9",
      s1: "Đăng+nhập", w: "1366:768", login: "1475511974", lowRes: "0"}

    MyVillage.all.each do |my_village|
      my_village.farm_for_village response.cookies
    end
  end
end
# whenever --update-crontab --set environment=development
