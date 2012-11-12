class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.references :company
      t.boolean :draft, default: false

      t.timestamps
    end
    add_index :projects, :company_id
  end
end
