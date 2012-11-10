class CreateEntityLocations < ActiveRecord::Migration
  def change
    create_table :location_bindings do |t|
      t.references :entity, polymorphic: true
      t.references :location
      t.timestamps
    end
    add_index :location_bindings, [:entity_id, :entity_type]
    add_index :location_bindings, :location_id
  end
end
