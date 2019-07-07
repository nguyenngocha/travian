require "rest-client"
require "nokogiri"

namespace :job do
  desc "TODO"
  task farm_all: :environment do

    # sleep rand 3*60

    User.all.each do  |user|
      @cookies = Relogin.new(user).run
  
      FarmGold.new(@cookies, user).execute
  
      puts "___________________________________________________________"
    end
  end
end
