class CreateOasises < ActiveRecord::Migration[5.0]
  def change
    create_table :oasises do |t|
      t.integer :bonus_wood
      t.integer :bonus_clay
      t.integer :bonus_iron
      t.integer :bonus_crop
      t.integer :rat
      t.integer :spider
      t.integer :snake
      t.integer :bat
      t.integer :wild_boar
      t.integer :wolf
      t.integer :bear
      t.integer :crocodile
      t.integer :tiger
      t.integer :elephant
      t.references :land, foreign_key: true

      t.timestamps
    end
  end
end
