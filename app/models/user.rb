class User < ApplicationRecord
  has_many :my_villages
  enum race: [:romans, :teutons, :gauls]
end
