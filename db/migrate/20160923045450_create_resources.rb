class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.integer :gid
      t.integer :level
      t.string :link
      t.boolean :upgrade
      t.references :my_village, foreign_key: true

      t.timestamps
    end
  end
end
