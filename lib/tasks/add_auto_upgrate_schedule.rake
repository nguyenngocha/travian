namespace :db do
  desc "TODO"
  task add_auto_upgrate_schedule: :environment do
    add_auto_upgrate_file = File.open "db/upgrate_schudule.txt", "r"
    add_auto_upgrate_file.each do |line|
      data = line.strip.split
      UpgrateSchedule.create! user_id: data[0], my_village_id: data[1], upgrate_id: data[2]
      # puts "UpgrateSchedule.create! user_id: #{data[0]}, my_village_id: #{data[1]}, upgrate_id: #{data[2]}"
      system "rm db/upgrate_schudule.txt"
      add_auto_upgrate_file = File.open "db/upgrate_schudule.txt", "w"
    end
  end
end
