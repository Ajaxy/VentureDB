class AddFoundationDateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :foundation_date, :string
  end
end
