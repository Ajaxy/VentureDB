class AddLegalInfoToPeople < ActiveRecord::Migration
  def change
    add_column :people, :legal_title, :string
    add_column :people, :legal_address, :string
    add_column :people, :legal_ogrn, :string
    add_column :people, :legal_inn, :string
  end
end
