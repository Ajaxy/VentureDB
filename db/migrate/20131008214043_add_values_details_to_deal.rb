class AddValuesDetailsToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :value_before_approx, :boolean
    add_column :deals, :value_before_approx_note, :text
    add_column :deals, :value_after_approx, :boolean
    add_column :deals, :value_after_approx_note, :text
  end
end
