namespace :db do
  desc "Import data"
  task :special do
    Rake::Task["db:special_lands"].invoke
  end
end
