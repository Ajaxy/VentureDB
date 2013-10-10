class AddFormatIdToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :format_id, :integer
  end
end
