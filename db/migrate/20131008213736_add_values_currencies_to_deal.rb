class AddValuesCurrenciesToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :value_before_usd, :integer
    add_column :deals, :value_before_eur, :integer
    add_column :deals, :value_after_usd, :integer
    add_column :deals, :value_after_eur, :integer
  end
end
