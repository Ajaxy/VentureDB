class CreateEventOrganizers < ActiveRecord::Migration
  def change
    create_table :event_organizers do |t|
      t.integer :event_id
      t.string :organizer_type
      t.integer :organizer_id
    end

    add_index :event_organizers, :event_id
    add_index :event_organizers, [:organizer_type, :organizer_id]
  end
end
