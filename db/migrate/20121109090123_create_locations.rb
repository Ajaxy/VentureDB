class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :full_name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
    add_index :locations, :name
    add_index :locations, :parent_id
    add_index :locations, :lft
    add_index :locations, :rgt
  end
end
