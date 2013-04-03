class ChangeAddressesType < ActiveRecord::Migration
  def up
    change_column :companies, :address1, :text
    change_column :companies, :address2, :text
    change_column :people, :address, :text
  end

  def down
    change_column :companies, :address1, :string
    change_column :companies, :address2, :string
    change_column :people, :address, :string
  end
end
