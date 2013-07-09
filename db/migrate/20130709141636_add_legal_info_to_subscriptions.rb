class AddLegalInfoToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :legal_title, :string
    add_column :subscriptions, :legal_address, :string
    add_column :subscriptions, :legal_ogrn, :string
    add_column :subscriptions, :legal_inn, :string
  end
end
