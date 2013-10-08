class AddInfoSourceToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :info_source, :text
  end
end
