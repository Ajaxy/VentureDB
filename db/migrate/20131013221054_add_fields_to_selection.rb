class AddFieldsToSelection < ActiveRecord::Migration
  def change
    add_column :selections, :status_id, :integer
    add_column :selections, :amount_from, :integer
    add_column :selections, :amount_to, :integer
    add_column :selections, :year, :integer
    add_column :selections, :quarter, :integer
  end
end
