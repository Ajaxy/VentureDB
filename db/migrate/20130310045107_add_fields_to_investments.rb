class AddFieldsToInvestments < ActiveRecord::Migration
  def change
    add_column :investments, :entity_type, :string
    add_column :investments, :entity_id,   :integer

    Investment.find_each do |inv|
      new_id   = inv.investor.actor_id
      new_type = inv.investor.actor_type

      inv.update_column :entity_id,   new_id
      inv.update_column :entity_type, new_type
    end

    remove_index  :investments, :investor_id
    remove_column :investments, :investor_id
  end
end
