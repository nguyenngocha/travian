class CreateMyVillages < ActiveRecord::Migration[5.0]
  def change
    create_table :my_villages do |t|
      t.string :name
      t.string :link
      t.integer :coordinate_x
      t.integer :coordinate_y
      t.integer :wood
      t.integer :clay
      t.integer :iron
      t.integer :max_warehouse
      t.integer :crop
      t.integer :max_granary
      t.integer :wood_quanity
      t.integer :clay_quanity
      t.integer :iron_quanity
      t.integer :crop_quanity
      t.boolean :upcrop, default: true
      t.boolean :upresource, default: true
      t.integer :wait_time, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
