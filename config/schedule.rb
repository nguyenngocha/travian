set :output, "/home/ubuntu/workspace/log.log"

# every 10.minutes do
#   rake "job:farm_all"
# end

every 5.minutes do
  rake "job:auto_upgrate_random_dorf1"
end

# every 10.minutes do
#   rake "job:auto_upgrate_random_dorf1"
# end

# whenever --update-crontab --set environment=development
