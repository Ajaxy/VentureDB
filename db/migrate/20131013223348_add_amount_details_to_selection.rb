class AddAmountDetailsToSelection < ActiveRecord::Migration
  def change
    add_column :selections, :amount_without_empty, :boolean
    add_column :selections, :amount_without_approx, :boolean
  end
end
