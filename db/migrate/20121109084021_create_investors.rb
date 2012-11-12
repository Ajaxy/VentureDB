class CreateInvestors < ActiveRecord::Migration
  def change
    create_table :investors do |t|
      t.references :actor, polymorphic: true
      t.references :type
      t.boolean :draft, default: false

      t.timestamps
    end
    add_index :investors, [:actor_id, :actor_type]
    add_index :investors, :type_id
  end
end
