class CreateArmies < ActiveRecord::Migration[5.0]
  def change
    create_table :armies do |t|
      t.integer :army1
      t.integer :army2
      t.integer :army3
      t.integer :army4
      t.integer :army5
      t.integer :army6
      t.integer :army7
      t.integer :army8
      t.integer :army9
      t.integer :army10
      t.integer :army11
      t.references :my_village, foreign_key: true

      t.timestamps
    end
  end
end
