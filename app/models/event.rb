class Event < ActiveRecord::Base
  INVOLVED_CLASSES = [Project, Investor, Company].freeze

  has_many :event_organizers
  has_many :event_participants

  INVOLVED_CLASSES.each do |klass|
    has_many "#{klass.to_s.downcase}_organizers", through: :event_organizers,
      source: :organizer, source_type: klass.to_s
    has_many "#{klass.to_s.downcase}_participants", through: :event_participants,
      source: :participant, source_type: klass.to_s
  end

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
