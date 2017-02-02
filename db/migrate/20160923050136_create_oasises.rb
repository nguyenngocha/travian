class CreateOasises < ActiveRecord::Migration[5.0]
  def change
    create_table :oasises do |t|
      t.integer :coordinate_x
      t.integer :coordinate_y
      t.float :distance

      t.integer :army1, default: 0, nil: false
      t.integer :army2, default: 0, nil: false
      t.integer :army3, default: 0, nil: false
      t.integer :army4, default: 0, nil: false
      t.integer :army5, default: 0, nil: false
      t.integer :army6, default: 0, nil: false
      t.integer :army7, default: 0, nil: false
      t.integer :army8, default: 0, nil: false
      t.integer :army9, default: 0, nil: false
      t.integer :army10, default: 0, nil: false
      t.integer :army11, default: 0, nil: false
      t.references :my_village, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
