class CreateScopes < ActiveRecord::Migration
  def change
    create_table :scopes do |t|
      t.string :name
      t.string :short_name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
    add_index :scopes, :parent_id
    add_index :scopes, :lft
    add_index :scopes, :rgt
  end
end
