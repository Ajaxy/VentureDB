class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :old_name, :string
  end
end
