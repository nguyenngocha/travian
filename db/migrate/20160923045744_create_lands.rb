class CreateLands < ActiveRecord::Migration[5.0]
  def change
    create_table :lands do |t|
      t.integer :coordinate_x
      t.integer :coordinate_y
      t.integer :army1, default: 0
      t.integer :army2, default: 0
      t.integer :army3, default: 0
      t.integer :army4, default: 0
      t.integer :army5, default: 0
      t.integer :army6, default: 0
      t.integer :army7, default: 0
      t.integer :army8, default: 0
      t.integer :army9, default: 0
      t.integer :army10, default: 0
      t.integer :army11, default: 0
      t.references :my_village, foreign_key: true

      t.timestamps
    end
  end
end
