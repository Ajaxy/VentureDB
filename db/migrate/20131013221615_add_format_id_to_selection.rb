class AddFormatIdToSelection < ActiveRecord::Migration
  def change
    add_column :selections, :format_id, :integer
  end
end
