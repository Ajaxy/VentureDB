class CreateCompanyScopes < ActiveRecord::Migration
  def change
    create_table :company_scopes do |t|
      t.integer :company_id
      t.integer :scope_id

      t.timestamps
    end

    add_index :company_scopes, [:company_id, :scope_id]
  end
end
