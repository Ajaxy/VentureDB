class AddAdditionalInfoAndHiddenInfoToPeople < ActiveRecord::Migration
  def change
    add_column :people, :details, :text
    add_column :people, :secret_details, :text
  end
end
