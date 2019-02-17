class MyVillage < ApplicationRecord
  belongs_to :user

  has_many :oasises, dependent: :destroy
  has_many :lands, dependent: :destroy
  has_many :armies, dependent: :destroy
  has_many :resources, dependent: :destroy
  has_many :upgrate_schedules, dependent: :destroy
  has_many :troop_schedules, dependent: :destroy

  attr_accessor :armies_field

  def farm_for_village cookies, active
    @lands = lands.shuffle
    @lands.each do |land|
      break unless farm_for_land land, cookies, active
      sleep rand*1
    end
  end

  def farm_for_v_oasis cookies, active
    @oasises = oasises.shuffle
    @oasises.each do |oasis|
      print "farm oasise (#{oasis.coordinate_x}, #{oasis.coordinate_y}) : "
      break unless farm_for_oasis oasis, cookies, active
      sleep rand*1
    end
  end

  private
  def farm_for_land land, cookies, active
    if Farms.new(cookies, self, land, active).send_request
      puts "#{name}: farm success (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance},
        #{land.army1}-#{land.army2}-#{land.army3}-#{land.army4}-#{land.army5}-#{land.army6}-#{land.army7}-#{land.army8}-#{land.army9}-#{land.army10}-#{land.army11}"
      return true
    else
      puts "#{name}: farm fail (#{land.coordinate_x}|#{land.coordinate_y}), distance: #{land.distance},
        #{land.army1}-#{land.army2}-#{land.army3}-#{land.army4}-#{land.army5}-#{land.army6}-#{land.army7}-#{land.army8}-#{land.army9}-#{land.army10}-#{land.army11}"
      return true
    end
  end

  def farm_for_oasis oasis, cookies, active
    if FarmOasis.new(cookies, self, oasis, active).send_request
      return true
    else
      return false
    end
  end
end
