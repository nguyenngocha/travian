namespace :job do
  desc "TODO"
  task farm_oasise: :environment do
    User.all.each do  |user|
      break unless farm_oasise user
      @cookies = Relogin.new(user).run
      puts "auto farm oasise for user: #{user.name}"

      user.my_villages.shuffle.each do |my_village|
        puts "auto farm oasise for village: #{my_village.name}"

        active = rand(1..1000)
        user.update_attributes! active: active
        puts "Active: #{user.active}"

        user.my_villages.first.farm_for_v_oasis @cookies, user.active
      end
      puts "======================================="
    end
  end

  def farm_oasise user
    user.my_villages.each do |my_village|
      if my_village.oasises.present?
        return true
      end
    end
    return false
  end
end
