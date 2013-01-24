class Event < ActiveRecord::Base
  has_many :event_organizers
  has_many :event_participants
  has_many :project_organizers, through: :event_organizers,
    source: :organizer, source_type: 'Project'
  has_many :investor_organizers, through: :event_organizers,
    source: :organizer, source_type: 'Investor'
  has_many :project_participants, through: :event_participants,
    source: :participant, source_type: 'Project'
  has_many :investor_participants, through: :event_participants,
    source: :participant, source_type: 'Investor'

  validates :name, presence: true

  def self.order_by_name(direction)
    order("#{table_name}.name #{direction}")
  end

  def organizers
    event_organizers.map &:organizer
  end

  def participants
    event_participants.map &:participant
  end
end
