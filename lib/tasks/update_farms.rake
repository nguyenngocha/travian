namespace :db do
  desc "TODO"
  task update_farms: :environment do
    system "crontab -r"
    user = User.first
    @cookies = Hash.new
    @cookies["T3E"] = user.t3e
    @cookies["lowRes"] = "0"
    @cookies["sess_id"] = user.sess_id
    # check login
    (1..3).each do
      response = RestClient.get "#{user.server}/dorf1.php", cookies: @cookies
      page = Nokogiri::HTML response
      if page.css("div#header ul#navigation").empty?
        puts "Da bi dang xuat"
        puts "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"
        sleep 0.5
        logout_res = RestClient.get "#{user.server}"
        logout_page = Nokogiri::HTML logout_res
        login = logout_page.css("input[name='login'] @value").text
        @login_res = RestClient.post "#{user.server}/dorf1.php",
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
    # GetFarmLands.new(@cookies, user.my_villages.second, 20, 30).get
    # GetFarmLands.new(@cookies, user.my_villages.second, 30, 40).get
    GetFarmLands.new(@cookies, user.my_villages.first, 0, 12).get
    
    system "whenever --update-crontab --set environment=development"
  end
end
