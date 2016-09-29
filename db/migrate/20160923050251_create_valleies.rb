class CreateValleies < ActiveRecord::Migration[5.0]
  def change
    create_table :valleies do |t|
      t.integer :type
      t.integer :wood
      t.integer :clay
      t.integer :iron
      t.integer :crop
      t.references :land, foreign_key: true

      t.timestamps
    end
  end
end
