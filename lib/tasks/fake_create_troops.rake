namespace :db do
  desc "Import land"
  task fake_create_troops: [:environment] do
    Oasise.destroy_all
    Oasise.create! coordinate_x: 43, coordinate_y: -1, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 49, coordinate_y: 3, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 49, coordinate_y: 4, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 46, coordinate_y: 2, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 48, coordinate_y: 3, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 42, coordinate_y: -4, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 41, coordinate_y: -4, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 43, coordinate_y: -2, army1: 2, user_id: 5, my_village_id: 17
    Oasise.create! coordinate_x: 44, coordinate_y: -5, army1: 2, user_id: 5, my_village_id: 17
  end
end
