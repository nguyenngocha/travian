class SessionsController < ApplicationController
  def new
  end

  def create
    logout_res = RestClient.get "https://ts6.travian.com.vn/logout.php"
    logout_page = Nokogiri::HTML logout_res
    login = logout_page.css("input[name='login'] @value").text
    login_res = RestClient.post "https://ts6.travian.com.vn/dorf1.php",
      {name: params[:session][:name], password: params[:session][:password],
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
      set_cookies login_res.cookies
      get_cookies
      UpdateDatabases.new(@page, @cookies).load_user(params[:session][:name],
        params[:session][:password], race)
      log_in User.find_by name: params[:session][:name]
      redirect_to my_villages_path
    end
  end

  def destroy
    RestClient.get "https://ts6.travian.com.vn/logout.php"
    log_out if logged_in?
    redirect_to root_url
  end
end
