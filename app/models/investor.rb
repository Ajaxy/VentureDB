# encoding: utf-8

class Investor < ActiveRecord::Base
  include Draftable
  include HasInvestments

  self.inheritance_column = "_type"

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings

  belongs_to :actor, polymorphic: true

  has_many :investments
  has_many :deals, through: :investments
  has_many :projects, through: :deals
  has_many :scopes, through: :projects

  validates :type_id, presence: true

  after_create :set_name

  TYPES = {
    1  => "Государственный фонд",
    2  => "Государственная организация",
    3  => "Корпорация",
    4  => "Корпоративный венчурный фонд",
    5  => "Частный венчурный фонд",
    6  => "Фонд прямых инвестиций",
    7  => "Фонд фондов",
    8  => "Инвестиционный банк",
    9  => "Инвестиционная компания",
    10  => "Прочие институциональные инвесторы (пенсионные фонды, страховые" +
          " компании и др.)",
    11 => "Бизнес-ангел",
    12 => "Прочие фонды",
    13 => "Прочие физлица (включая FFF)",
    14 => "Прочие организации (юрлица)",
  }

  PERSON_TYPES = [11, 13]

  define_index "investors_index" do
    indexes "ltrim(investors.name)", as: :name

    where "investors.draft = 'f'"
  end

  define_index "prefix_investors_index" do
    indexes "ltrim(investors.name)", as: :name

    where "investors.draft = 'f'"
    set_property min_prefix_len: 3
  end

  include Searchable

  def self.investors
  end

  def self.in_location(location)
    joins{locations}.where{(locations.lft >= location.lft) &
                           (locations.lft < location.rgt)}
  end

  def self.suggest(string)
    return scoped unless string.present?
    search = "%#{string}%".gsub('.','_')

    where{ name.like(search) }
  end

  def self.in_round(round)
    joins{deals.outer}.where{(deals.round_id == round) & (deals.published == true)}
  end

  def self.in_stage(stage)
    joins{deals.outer}.where{(deals.stage_id == stage) & (deals.published == true)}
  end

  def self.in_scope(scope)
    joins{deals.project.scopes}
      .where{deals.published == true}
      .where{(scopes.lft >= scope.lft) & (scopes.lft < scope.rgt)}
  end

  def self.in_scopes(scope_arr)
    joins{deals.project.scopes}
      .where{deals.published == true}
      .where{scopes.id.in scope_arr}
  end

  def self.in_rounds(rounds)
    joins{deals.outer}.where{(deals.round_id.in rounds) & (deals.published == true)}
  end

  def self.in_stages(stages)
    joins{deals.outer}.where{(deals.stage_id.in stages) & (deals.published == true)}
  end

  def self.in_types(types)
    ids = Investment::GRANT_INSTRUMENTS
    deal_types = case types
    when ['1']
      deal_types = joins{investments}.where{coalesce(investments.instrument_id, 0).not_in ids}
    when ['2']
      deal_types = joins{investments}.where{investments.instrument_id.in ids}
    else
      scoped.where{type_id.in types}
    end
    deal_types.joins{deals.outer}.where{(deals.published == true)}
  end

  def self.from_date(from)
    joins{deals.outer}.where{deals.published == true}
      .where('? < investments.created_at', from)
  end

  def self.till_date(till)
    joins{deals.outer}.where{deals.published == true}
      .where('investments.created_at < ?', till)
  end

  def self.sort_type(type)
    case type
    when '1'
      order_by_investments
    when '2'
      order_by_name('ASC')
    end
  end

  def self.order_by_type(direction)
    order("type_id #{direction}")
  end

  def self.order_by_name(direction)
    order("name #{direction}")
  end

  def self.order_by_investments
    joins{deals.outer}.order("deals_count DESC")
  end

  def person
    @person ||= is_person? ? actor : Person.new
  end

  def company
    @company ||= is_company? ? actor : Company.new
  end

  def company=(params)
    actor.update_attributes(params) if is_company?
  end

  def person=(params)
    actor.update_attributes(params) if is_person?
  end

  def is_company?
    actor.is_a?(Company)
  end

  def is_person?
    actor.is_a?(Person)
  end

  def self.with_actor
    where{(actor_id != nil) & (type_id != nil)}.includes{actor}
  end

  def name_and_type
    "#{name} – #{type}"
  end

  def type
    TYPES[type_id]
  end

  def publish
    super
    actor.try(:publish)
  end

  def last_deal_date
    published_deals.first.try(:date)
  end

  # def average_deal_amount
  #   deals.published.average(:amount_usd)
  # end

  private

  def set_name
    update_column :name, actor.name if actor
  end
end
