class AddDescriptionToCompanyAndPerson < ActiveRecord::Migration
  def change
    add_column :companies, :description, :text
    add_column :people, :description, :text
  end
end
