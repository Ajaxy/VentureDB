class AddTypeToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :type, :string
  end
end
