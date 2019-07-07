class UpgrateSchedule < ApplicationRecord
  belongs_to :my_village

  attr_reader :upgrate_times;
end
