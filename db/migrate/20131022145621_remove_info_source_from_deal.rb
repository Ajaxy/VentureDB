class RemoveInfoSourceFromDeal < ActiveRecord::Migration
  def change
    remove_column :deals, :info_source
  end
end
