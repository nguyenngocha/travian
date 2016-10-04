set :output, "/home/o-o/log.log"

every 10.minutes do
  rake "job:farm_all"
end
