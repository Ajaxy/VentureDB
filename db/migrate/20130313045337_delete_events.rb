class DeleteEvents < ActiveRecord::Migration
  def up
    drop_table :event_organizers
    drop_table :event_participants
    drop_table :events
  end
end