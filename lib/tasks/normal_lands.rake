namespace :db do
  desc "Import land"
  task normal_lands: [:environment] do
    Land.delete_all

    # hatd2
    Land.create! coordinate_x: -45, coordinate_y: 15,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -43, coordinate_y: 7,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -50, coordinate_y: 5,
      army1: 0, army2: 0, army3: 0, army4: 50, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -53, coordinate_y: 4,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -47, coordinate_y: 6,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -52, coordinate_y: 1,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -50, coordinate_y: -2,
      army1: 0, army2: 0, army3: 0, army4: 30, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -42, coordinate_y: -2,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -42, coordinate_y: 5,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -39, coordinate_y: 10,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -48, coordinate_y: 18,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -50, coordinate_y: 21,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -49, coordinate_y: 23,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -47, coordinate_y: -7,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -48, coordinate_y: -11,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1
    Land.create! coordinate_x: -46, coordinate_y: 1,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 2, user_id: 1

      # hatd1
    Land.create! coordinate_x: -32, coordinate_y: 1,
      army1: 0, army2: 0, army3: 0, army4: 10, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -31, coordinate_y: 3,
      army1: 0, army2: 0, army3: 0, army4: 10, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -34, coordinate_y: 0,
      army1: 0, army2: 0, army3: 0, army4: 10, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -35, coordinate_y: 3,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -38, coordinate_y: -10,
      army1: 0, army2: 0, army3: 0, army4: 50, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -34, coordinate_y: -10,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -33, coordinate_y: -11,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -27, coordinate_y: -12,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -32, coordinate_y: -15,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -27, coordinate_y: -5,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
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
    Land.create! coordinate_x: -25, coordinate_y: 13,
      army1: 0, army2: 0, army3: 0, army4: 15, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
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
    Land.create! coordinate_x: -21, coordinate_y: 32,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -20, coordinate_y: 25,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -10, coordinate_y: 6,
      army1: 0, army2: 0, army3: 0, army4: 50, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -22, coordinate_y: 0,
      army1: 0, army2: 0, army3: 0, army4: 10, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -15, coordinate_y: -1,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -19, coordinate_y: -9,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -14, coordinate_y: 1,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
    Land.create! coordinate_x: -15, coordinate_y: 2,
      army1: 0, army2: 0, army3: 0, army4: 20, army5: 0, army6: 0, army7: 0,
      army8: 0, army9: 0, army10: 0, army11: 0, my_village_id: 1, user_id: 1
  end
end
