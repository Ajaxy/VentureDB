class AddArchivedAtToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :archived_at, :datetime
    add_index :subscriptions, :archived_at
    add_index :subscriptions, :email
  end
end
