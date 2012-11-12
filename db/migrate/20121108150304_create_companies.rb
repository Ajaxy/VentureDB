class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :full_name
      t.string :place
      t.string :form
      t.boolean :draft, default: false

      t.timestamps
    end
  end
end
