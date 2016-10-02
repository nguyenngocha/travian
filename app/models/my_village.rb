class MyVillage < ApplicationRecord
  belongs_to :user

  has_many :lands, dependent: :destroy
  has_many :armies, dependent: :destroy
  has_many :resources, dependent: :destroy

  attr_accessor :armies_field

  def farm_for_village cookies
    @lands = lands.shuffle
    @lands.each do |land|
      break unless farm_for_land land, cookies
      sleep(3)
    end
  end
  def farm_for_land land, cookies
    if Farms.new(cookies, self, land).send_request
      puts "#{name}: farm success (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance}"
      return true
    else
      puts "#{name}: farm fail (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance}"
      return false
    end
  end
end
