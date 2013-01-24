class EventOrganizer < ActiveRecord::Base
  belongs_to :event
  belongs_to :organizer, polymorphic: true
end
