class SessionsController < ApplicationController
  def new
  end

  def create
    response = RestClient.post "http://ts19.travian.com.vn/dorf1.php",
      {name: params[:session][:name], password: params[:session][:password],
      s1: "Đăng+nhập", w: "1366:768", login: "1474387509", lowRes: "0"}
    @page = Nokogiri::HTML(response)
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
      set_cookies response.cookies
      get_cookies
      UpdateDatabases.new(@page, @cookies).load_user(params[:session][:name],
        params[:session][:password], race)
      log_in User.find_by name: params[:session][:name]
      redirect_to farms_path
    end
  end
end
