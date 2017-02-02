class CreateUpgrateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :upgrate_schedules do |t|
      t.references :user, foreign_key: true
      t.references :my_village, foreign_key: true
      t.integer :upgrate_id

      t.timestamps
    end
  end
end
