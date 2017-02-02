namespace :db do
  desc "Import land"
  task update_databases: [:environment] do
    logout_res = RestClient.get "http://ts19.travian.com.vn/logout.php"
    logout_page = Nokogiri::HTML logout_res
    login = logout_page.css("input[name='login'] @value").text
    login_res = RestClient.post "http://ts19.travian.com.vn/dorf1.php",
      {name: "farm", password: "1234",
      s1: "Đăng+nhập", w: "1366:768", login: login, lowRes: "0"}
    @page = Nokogiri::HTML login_res
    if @page.css("div#header ul#navigation").empty?
      flash[:danger] = "Dang nhap loi"
      redirect_to login_path
    else
      race = if @page.css("div.playerName img.nation1").present?
        0
      elsif @page.css("div.playerName img.nation2").present?
        1
      elsif @page.css("div.playerName img.nation3").present?
        2
      end
      UpdateDatabases.new(@page, login_res.cookies).load_user("farm",
        "1234", race)
    end
  end
end
