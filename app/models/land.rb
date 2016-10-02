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
end
