class Land < ApplicationRecord
  validates :coordinate_x, presence: true
  validates :coordinate_y, presence: true
end
