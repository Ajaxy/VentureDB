class AddFieldsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :name, :string
    add_column :subscriptions, :company, :string
  end
end
