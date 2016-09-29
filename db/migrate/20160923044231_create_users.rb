class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.integer :race
      t.string :proxy
      t.string :t3e
      t.string :lowres
      t.string :sess_id

      t.timestamps
    end
  end
end
