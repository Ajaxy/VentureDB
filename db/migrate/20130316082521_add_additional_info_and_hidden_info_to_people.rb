class AddAdditionalInfoAndHiddenInfoToPeople < ActiveRecord::Migration
  def change
    add_column :people, :additional_info, :text
    add_column :people, :hidden_info, :text
  end
end
