class StaticPagesController < ApplicationController
  def home
    response = RestClient.get "http://whatismyipaddress.com"
    @page = Nokogiri::HTML(response)

    @ip = @page.css("div#main_content @href")[0].value.split(/[^\d, .]/).join
  end
end
