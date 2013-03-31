class AddEmailsCompanies < ActiveRecord::Migration
  def up
    add_column :companies, :email1, :string
    add_column :companies, :email2, :string
  end

  def down
    remove_column :companies, :email1
    remove_column :companies, :email2
  end
end
