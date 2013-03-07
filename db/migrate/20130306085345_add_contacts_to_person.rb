class AddContactsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :contacts, :text
  end
end
