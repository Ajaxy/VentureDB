class AddLegalInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :legal_title, :string
    add_column :users, :legal_address, :string
    add_column :users, :legal_ogrn, :string
    add_column :users, :legal_inn, :string
  end
end
