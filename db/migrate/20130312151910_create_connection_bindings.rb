class CreateConnectionBindings < ActiveRecord::Migration
  def change
    create_table :connection_bindings, id: false do |t|
      t.references :connect_from, polymorphic: true
      t.references :connect_to,   polymorphic: true
      t.timestamps
    end
  end
end
