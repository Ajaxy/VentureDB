class AddFormatToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :format, :integer
  end
end
