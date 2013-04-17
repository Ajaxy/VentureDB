# encoding: utf-8

class Company < ActiveRecord::Base
  include Trackable
  include Draftable
  include InvestorActor
  include Connectable

  TYPE_INVESTOR_ID = 1
  TYPE_INNOVATION_ID = 2

  TYPES = {
    TYPE_INVESTOR_ID => "Инвестор",
    TYPE_INNOVATION_ID => "Инновационная компания",

    10 => "Ассоциация или бизнес-сообщество",
    11 => "Сервисный провайдер",
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
    34 => "Бизнес-инкубатор",
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
  has_many :deals

  has_many :company_scopes
  has_many :scopes, through: :company_scopes

  has_many :location_bindings, as: :entity
  has_many :markets, through: :location_bindings, source: :location

  # validates :name, :full_name, :form, :place, presence: true
  validates :name, presence: true
  validates :type_id, inclusion: { in: TYPES.keys }, allow_nil: true

  scope :investors, -> { where(type_id: TYPE_INVESTOR_ID) }
  scope :innovation, -> { where(type_id: TYPE_INNOVATION_ID) }

  define_index "companies_index" do
    indexes "ltrim(companies.name)", as: :name
    indexes full_name
    indexes description

    where "companies.draft = 'f'"
  end

  define_index "companies_prefix_index" do
    indexes "ltrim(companies.name)", as: :name
    indexes full_name
    indexes description

    where "companies.draft = 'f'"
    set_property min_prefix_len: 3
  end

  include Searchable

  def self.types
    types = TYPES.dup
    #types.delete_if { |id, name| id < 10 }
    types.invert
  end

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

  def self.in_types(type_ids)
    where{type_id.in type_ids}
  end

  def self.in_scopes(scope_ids)
    joins{scopes}.where{scopes.id.in scope_ids}
  end

  def self.sort_type(type)
    case type
    when '1'
      order_by_investments
    else
      order_by_name('ASC')
    end
  end

  def self.order_by_name(direction)
    order("trim(companies.name) #{direction}")
  end

  def self.order_by_investments
    joins{deals.outer}.
      where{deals.published == true}.
      group{id}.
      order("sum(deals.amount_usd) desc nulls last")
  end

  def self.in_rounds(rounds)
    joins{deals.outer}.where{(deals.round_id.in rounds) & (deals.published == true)}
  end

  def self.in_stages(stages)
    joins{deals.outer}.where{(deals.stage_id.in stages) & (deals.published == true)}
  end

  def self.in_amount_range(from, to)
    joins{deals.outer}.group{id}.
      where{deals.published == true}.
      where{(deals.amount_usd >= from) & (deals.amount_usd <= to)}
  end

  def deals
    investor? ? investors.sum(&:deals) : super
  end

  def investor?
    type_id == TYPE_INVESTOR_ID && investors.any?
  end
end
