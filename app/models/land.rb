class Land < ApplicationRecord
  validates :type_id, presence: true
  validates :coordinate_x, presence: true
  validates :coordinate_y, presence: true
end
