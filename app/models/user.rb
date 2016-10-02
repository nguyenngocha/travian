class User < ApplicationRecord
  has_many :my_villages
  has_many :lands
  enum race: [:romans, :teutons, :gauls]
end
