namespace :create do
  desc "TODO"
  task troop: :environment do
    user = User.first
    @cookies = Hash.new
    @cookies["T3E"] = user.t3e
    @cookies["lowRes"] = "0"
    @cookies["sess_id"] = user.sess_id
    (1..3).each do
      response = RestClient.get "https://ts6.travian.com.vn/dorf1.php", cookies: @cookies
      page = Nokogiri::HTML response
      if page.css("div#header ul#navigation").empty?
        puts "Da bi dang xuat"
        puts "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"
        sleep 0.5
        logout_res = RestClient.get "https://ts6.travian.com.vn"
        logout_page = Nokogiri::HTML logout_res
        login = logout_page.css("input[name='login'] @value").text
        @login_res = RestClient.post "https://ts6.travian.com.vn/dorf1.php",
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
    puts "Active: #{user.active}"

    user.my_villages.each do |my_village|
      my_village.troop_schedules.each do |ts|
        CreateTroop.new(@cookies, my_village, user.active, ts).execute
      end
    end
  end
end
