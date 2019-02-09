namespace :db do
  desc "Import land"
  task fake_lands: [:environment] do
    Oasise.delete_all

    Oasise.create! coordinate_x: 28, coordinate_y: -18, my_village_id: 1, army1: 5
    Oasise.create! coordinate_x: 32, coordinate_y: -12, my_village_id: 1, army4: 2
    Oasise.create! coordinate_x: 32, coordinate_y: -13, my_village_id: 1, army4: 2
    Oasise.create! coordinate_x: 31, coordinate_y: -13, my_village_id: 1, army4: 2
    Oasise.create! coordinate_x: 34, coordinate_y: -19, my_village_id: 1, army4: 2
    Oasise.create! coordinate_x: 28, coordinate_y: -18, my_village_id: 1, army4: 2
  end
end
