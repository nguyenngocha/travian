class CreateLands < ActiveRecord::Migration[5.0]
  def change
    create_table :lands do |t|
      t.integer :type_id
      t.integer :coordinate_x
      t.integer :coordinate_y

      t.timestamps
    end
  end
end
