class AddPublishedToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :published, :boolean, default: false
  end
end
