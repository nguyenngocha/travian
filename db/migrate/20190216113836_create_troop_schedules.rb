class CreateTroopSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :troop_schedules do |t|
      t.integer :troop_id
      t.integer :troop_number
      t.integer :build_id
      t.references :my_village, foreign_key: true

      t.timestamps
    end
  end
end
