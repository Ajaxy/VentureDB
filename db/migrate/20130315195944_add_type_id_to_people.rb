class AddTypeIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :type_id, :integer
  end
end
