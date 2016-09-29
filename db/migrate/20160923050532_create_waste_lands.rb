class CreateWasteLands < ActiveRecord::Migration[5.0]
  def change
    create_table :waste_lands do |t|
      t.integer :type
      t.references :land, foreign_key: true

      t.timestamps
    end
  end
end
