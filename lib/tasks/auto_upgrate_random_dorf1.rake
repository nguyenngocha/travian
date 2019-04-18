namespace :job do
  desc "TODO"
  task upgrate: :environment do
    sleep rand 3*60

    User.all.each do  |user|
      @cookies = Relogin.new(user).run

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
end
