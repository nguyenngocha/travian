namespace :job do
  desc "TODO"
  task upgrate: :environment do
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
        logout_res = RestClient.get "#{user.server}"
        logout_page = Nokogiri::HTML logout_res
        login = logout_page.css("input[name='login'] @value").text
        @login_res = RestClient.post "#{user.server}/dorf1.php",
          {server: user.server, name: user.name, password: user.password,
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
      puts "auto upgrate for #{my_village.name}"

      if my_village.update_inner_list.present?
        UpgrateInDorf.new(@cookies, my_village, user.active).send_request
      end
      RandomUpgrateOutDorf.new(@cookies, my_village, user.active).send_request

    end
    puts "======================================="
  end
end