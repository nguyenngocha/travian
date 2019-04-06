namespace :job do
  desc "TODO"
  task upgrate: :environment do
    sleep rand 3*60
    user = User.first
    @cookies = Hash.new
    @cookies["T3E"] = user.t3e
    @cookies["lowRes"] = "0"
    @cookies["sess_id"] = user.sess_id
    # check login
    (1..3).each do
      @headers = {
        cookies: @cookies,
        accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "ja,en-US;q=0.9,en;q=0.8",
        "referer": "",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
      }
      response = RestClient.get "#{user.server}/dorf1.php", @headers
      page = Nokogiri::HTML response
      if page.css("div#header ul#navigation").empty?
        puts "Da bi dang xuat"
        puts "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"

        @headers = {
          accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
          "accept-encoding": "gzip, deflate, br",
          "accept-language": "ja,en-US;q=0.9,en;q=0.8",
          "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36",
          "referer": "#{user.server}/dorf1.php"
        }
        logout_res = RestClient.get "#{user.server}", @headers
        logout_page = Nokogiri::HTML logout_res
        login = logout_page.css("input[name='login'] @value").text

        @params = {
          server: user.server,
          name: user.name,
          password: user.password,
          s1: "Đăng+nhập",
          w: "1366:768",
          login: login,
          lowRes: "0"
        }

        @headers = {
          accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
          "accept-encoding": "gzip, deflate, br",
          "accept-language": "ja,en-US;q=0.9,en;q=0.8",
          "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36",
          "referer": "#{user.server}"
        }

        @login_res = RestClient.post "#{user.server}/dorf1.php", @params, @headers
        login_page = Nokogiri::HTML @login_res
        unless login_page.css("div#header ul#navigation").empty?
          user.update_attributes! t3e: @login_res.cookies["T3E"], sess_id: @login_res.cookies["sess_id"]
          puts "Da dang nhap lai"
          @cookies["T3E"] = @login_res.cookies["T3E"]
          @cookies["sess_id"] = @login_res.cookies["sess_id"]
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