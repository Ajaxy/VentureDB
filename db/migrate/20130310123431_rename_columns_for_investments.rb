class RenameColumnsForInvestments < ActiveRecord::Migration
  def up
    rename_column :investments, :entity_id, :investor_entity_id
    rename_column :investments, :entity_type, :investor_entity_type
  end
  def down
    rename_column :investments, :investor_entity_id, :entity_id
    rename_column :investments, :investor_entity_type, :entity_type
  end
end
