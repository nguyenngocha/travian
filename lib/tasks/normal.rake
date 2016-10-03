namespace :db do
  desc "Import data"
  task :normal do
    Rake::Task["db:normal_lands"].invoke
  end
end
