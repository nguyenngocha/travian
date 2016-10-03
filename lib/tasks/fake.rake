namespace :db do
  desc "Import data"
  task :fake do
    Rake::Task["db:fake_lands"].invoke
  end
end
