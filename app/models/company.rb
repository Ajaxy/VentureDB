# encoding: utf-8

class Company < ActiveRecord::Base
  include Trackable
  include Draftable
  include InvestorActor
  include Connectable

  TYPE_INVESTOR_ID = 1

  TYPES = {
    TYPE_INVESTOR_ID => "Инвестор",
    2 => "Инновационная компания",

    10 => "Ассоциация или бизнес-сообщество",
    11 => "Севисный провайдер",
    12 => "Консалтинг",
    13 => "Медиа и СМИ",

    21 => "Форумы, конференции, круглые столы",
    22 => "Ярмарки, выставки",
    23 => "Обучающие семинары, курсы",
    24 => "Конкурсы инновационных проектов",
    25 => "Программы поддержки инновационного предпринимательства",

    31 => "Технопарк, ИТЦ",
    32 => "Вузовский центр",
    33 => "Бизнес-катализатор, бизнес-акселератор",
    34 => "Бизнес-катализатор",
    35 => "Инновационный ВУЗ",
    36 => "Прочие образовательные центры (кроме ВУЗов)",
    37 => "ОЭЗ, технико-внедренческая зона, технополис",
    38 => "НИИ, центр прикладных исследований",
    39 => "Научный парк",

    40 => "Центр прототипирования и дизайна",
    41 => "Центр продвижения и трансфера технологий",
    42 => "Центр катализации (seed house)",
    43 => "Центр коллективного пользования",
    44 => "Прочие центры"
  }

  has_many :users
  has_one :project

  has_many :company_scopes
  has_many :scopes, through: :company_scopes

  has_many :location_bindings, as: :entity
  has_many :markets, through: :location_bindings, source: :location

  # validates :name, :full_name, :form, :place, presence: true
  validates :name, presence: true
  validates :type_id, inclusion: { in: TYPES.keys }, allow_nil: true

  scope :investors, -> { where(type_id: 1) }

  def self.find_or_create(params, user)
    if company = where(params.slice(:name)).first
      company
    else
      create_tracking_user(user, params)
    end
  end

  def self.infrastructure
    where("type_id >= 10")
  end

  def self.suggest(query)
    return scoped unless query.present?
    search = "%#{query}%".gsub('.','_')

    where{ name.like(search) }
  end

  def self.order_by_name(direction)
    order("#{table_name}.name #{direction}")
  end
end
