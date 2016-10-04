set :output, "/var/log/log.log"

every 10.minutes do
  rake "job:farm_all"
end
