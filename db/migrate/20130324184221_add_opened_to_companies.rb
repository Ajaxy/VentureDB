class AddOpenedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :opened, :boolean, null: false, default: false
  end
end
