class CreateVillages < ActiveRecord::Migration[5.0]
  def change
    create_table :villages do |t|
      t.integer :type
      t.integer :race
      t.string :owner
      t.string :clan
      t.integer :population
      t.references :land, foreign_key: true

      t.timestamps
    end
  end
end
