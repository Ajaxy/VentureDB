class AddApproxAmountNoteToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :approx_amount_note, :text
  end
end
