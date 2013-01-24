class CreateEventParticipants < ActiveRecord::Migration
  def change
    create_table :event_participants do |t|
      t.string :participant_type
      t.integer :participant_id
      t.integer :event_id
    end

    add_index :event_participants, :event_id
    add_index :event_participants, [:participant_type, :participant_id]
  end
end
