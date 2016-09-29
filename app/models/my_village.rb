class MyVillage < ApplicationRecord
  belongs_to :user

  has_many :armies, dependent: :destroy
  has_many :resources, dependent: :destroy
end
