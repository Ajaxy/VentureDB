class RemovePeopleTypes < ActiveRecord::Migration
  def change
    rename_column :people, :type, :type_
  end
end
