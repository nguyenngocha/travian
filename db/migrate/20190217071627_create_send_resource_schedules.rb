class CreateSendResourceSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :send_resource_schedules do |t|
      t.references :my_village, foreign_key: true
      t.integer :target_x
      t.integer :target_y
      t.integer :wood
      t.integer :clay
      t.integer :iron
      t.integer :paddy
      t.integer :market_id

      t.timestamps
    end
  end
end
