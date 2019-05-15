class Relogin
  require "rest-client"
  require "nokogiri"

  def initialize user
    @user = user
  end

  def run
    @cookies = Hash.new
    @cookies["T3E"] = @user.t3e
    @cookies["lowRes"] = "0"
    @cookies["sess_id"] = @user.sess_id
    # check login
    @headers = {
      cookies: @cookies,
      "referer": "",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
    }
    response = RestClient.get "#{@user.server}/dorf1.php", @headers
    page = Nokogiri::HTML response
    if page.css("div#header ul#navigation").empty?
      puts "Da bi dang xuat"
      puts "#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}"

      @headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36",
        "referer": "#{@user.server}/dorf1.php"
      }
      logout_res = RestClient.get "#{@user.server}", @headers
      logout_page = Nokogiri::HTML logout_res
      login = logout_page.css("input[name='login'] @value").text

      @params = {
        server: @user.server,
        name: @user.name,
        password: @user.password,
        s1: "Đăng+nhập",
        w: "1366:768",
        login: login,
        lowRes: "0"
      }

      @headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36",
        "referer": "#{@user.server}"
      }

      @login_res = RestClient.post "#{@user.server}/dorf1.php", @params, @headers
      login_page = Nokogiri::HTML @login_res
      unless login_page.css("div#header ul#navigation").empty?
        @user.update_attributes! t3e: @login_res.cookies["T3E"], sess_id: @login_res.cookies["sess_id"]
        puts "Da dang nhap lai"
        @cookies["T3E"] = @login_res.cookies["T3E"]
        @cookies["sess_id"] = @login_res.cookies["sess_id"]
      end
    else
      puts "Van dang nhap"
    end
    return @cookies
  end
end
