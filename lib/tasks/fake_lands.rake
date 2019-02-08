namespace :db do
  desc "Import land"
  task fake_lands: [:environment] do
    Oasise.delete_all

    Oasise.create! coordinate_x: 34, coordinate_y: -19, my_village_id: 1, army1: 5
  end
end
