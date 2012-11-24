class AddNewFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :creation_date, :date
    add_column :companies, :contacts, :text
    add_column :companies, :employees, :text
    add_column :companies, :founders, :text
    add_column :companies, :direction, :text

    add_column :projects, :investments_string, :text
    add_column :projects, :suppliers, :text
    add_column :projects, :competitors, :text
    add_column :projects, :experience, :text
    add_column :projects, :competitions, :text
    add_column :projects, :accelerators, :text
    add_column :projects, :need_for_investments, :text

    add_column :projects, :errors_log, :text
  end
end
