namespace :db do
  desc "Import land"
  task special_lands: [:environment] do
    Land.delete_all

    Land.create! coordinate_x: -32, coordinate_y: 25,
      army1: 0, army2: 0, army3: 0, army4: 100, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -28, coordinate_y: 26,
      army1: 0, army2: 0, army3: 0, army4: 100, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -31, coordinate_y: 27,
      army1: 0, army2: 0, army3: 0, army4: 100, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -32, coordinate_y: 27,
      army1: 0, army2: 300, army3: 0, army4: 0, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -32, coordinate_y: 28,
      army1: 0, army2: 0, army3: 0, army4: 0, army5: 0, army6: 150, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -27, coordinate_y: 16,
      army1: 0, army2: 0, army3: 0, army4: 100, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -26, coordinate_y: 21,
      army1: 0, army2: 0, army3: 0, army4: 100, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -32, coordinate_y: 19,
      army1: 0, army2: 0, army3: 0, army4: 100, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
  end
end
