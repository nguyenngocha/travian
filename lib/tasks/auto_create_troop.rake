namespace :job do
  desc "TODO"
  task create_troop: :environment do
    # sleep rand 3*60

    User.all.each do  |user|
      break unless check_create_troop user
      @cookies = Relogin.new(user).run
      # fake_request @cookies, user

      user.my_villages.shuffle.each do |my_village|
        my_village.troop_schedules.each do |ts|
          puts "auto create troop for #{my_village.name}"
          CreateTroop.new(@cookies, my_village, user.active, ts).execute
        end
      end
      puts "======================================="
    end
  end

  def check_create_troop user
    user.my_villages.each do |my_village|
      return true if my_village.troop_schedules.present?
    end
    return false
  end
end
