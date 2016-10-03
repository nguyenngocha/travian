namespace :db do
  desc "Import land"
  task fake_lands: [:environment] do
    Land.delete_all

    Land.create! coordinate_x: -24, coordinate_y: 2,
      army1: 0, army2: 0, army3: 0, army4: 0, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
  end
end
