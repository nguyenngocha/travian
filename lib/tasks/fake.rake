namespace :db do
  desc "Import data"
  task :fake do
    Rake::Task["db:fake_create_troops"].invoke
  end
end
