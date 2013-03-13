class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :from_type
      t.integer :from_id
      t.string :to_type
      t.integer :to_id
      t.integer :connection_type_id

      t.timestamps
    end
  end
end
