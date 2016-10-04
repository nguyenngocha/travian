class Land < ApplicationRecord
  validates :coordinate_x, presence: true
  validates :coordinate_y, presence: true
  validates :army1, presence: true
  validates :army2, presence: true
  validates :army3, presence: true
  validates :army4, presence: true
  validates :army5, presence: true
  validates :army6, presence: true
  validates :army7, presence: true
  validates :army8, presence: true
  validates :army9, presence: true
  validates :army10, presence: true
  validates :army11, presence: true

  before_save :calculate_distance

  scope :order_by_distance,-> {order distance: :asc}
  scope :order_by_village,-> {order my_village_id: :asc}

  def calculate_distance
    unless my_village_id.nil?
      current_village = MyVillage.find_by id: my_village_id
      self.distance = (Math.sqrt((current_village.coordinate_x - coordinate_x).abs**2 + (current_village.coordinate_y - coordinate_y).abs**2)).round(1)
    end
  end
end
