class AddExpertToPeople < ActiveRecord::Migration
  def change
    add_column :people, :expert, :boolean, null: false, default: false
  end
end
