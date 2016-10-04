class MyVillage < ApplicationRecord
  belongs_to :user

  has_many :lands, dependent: :destroy
  has_many :armies, dependent: :destroy
  has_many :resources, dependent: :destroy

  attr_accessor :armies_field

  def farm_for_village cookies
    @lands = lands.order_by_distance
    @lands.each do |land|
      break unless farm_for_land land, cookies
      sleep(3)
    end
  end
  def farm_for_land land, cookies
    if Farms.new(cookies, self, land).send_request
      puts "#{name}: farm success (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance},
        #{land.army1}-#{land.army2}-#{land.army3}-#{land.army4}-#{land.army5}-#{land.army6}-#{land.army7}-#{land.army8}-#{land.army9}-#{land.army10}-#{land.army11}"
      return true
    else
      puts "#{name}: farm fail (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance},
        #{land.army1}-#{land.army2}-#{land.army3}-#{land.army4}-#{land.army5}-#{land.army6}-#{land.army7}-#{land.army8}-#{land.army9}-#{land.army10}-#{land.army11}"
      return false
    end
  end
end
