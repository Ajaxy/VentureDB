class AddTypeIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :type_id, :integer
  end
end
