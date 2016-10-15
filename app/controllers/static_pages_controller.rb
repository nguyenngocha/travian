class StaticPagesController < ApplicationController
  def home
    response = RestClient.get "http://whatismyipaddress.com"
    @page = Nokogiri::HTML(response)

    @ip = @page.css("div#main_content @href")[0].value.split(/[^\d, .]/).join
  end

  def start
    system "whenever --update-crontab --set environment=development"
    redirect_to lands_path
  end

  def stop
    system "crontab -r"
    current_user.update_attributes! active: 0
    redirect_to lands_path
  end
end
