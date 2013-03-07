# encoding: utf-8
class Event < Company
  INVOLVED_CLASSES = [Project, Investor, Company].freeze
  TYPES = {
    1 => "Форумы, конференции, круглые столы",
    2 => "Ярмарки, выставки",
    3 => "Обучающие семинары, курсы",
    4 => "Конкурсы инновационных проектов",
    5 => "Программы поддержки инновационного предпринимательства"
  }

  has_many :event_organizers
  has_many :event_participants

  INVOLVED_CLASSES.each do |klass|
    has_many "#{klass.to_s.downcase}_organizers", through: :event_organizers,
      source: :organizer, source_type: klass.to_s
    has_many "#{klass.to_s.downcase}_participants", through: :event_participants,
      source: :participant, source_type: klass.to_s
  end

  validates :type_id, inclusion: { in: TYPES.keys }, allow_nil: true

  def organizers
    event_organizers.map &:organizer
  end

  def participants
    event_participants.map &:participant
  end
end
