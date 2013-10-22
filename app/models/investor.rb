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

  delegate :place, to: :company, allow_nil: true

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

  AMOUNT_RANGES = {
    1 => 0..500_000,
    2 => 500_000..3_000_000,
    3 => 3_000_000..10_000_000,
    4 => 10_000_000..1_000_000_000
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

  def self.in_location(location)
    joins{locations}.where{(locations.lft >= location.lft) &
                           (locations.lft < location.rgt)}
  end

  def self.suggest(string)
    return scoped unless string.present?
    search = "%#{string}%".gsub('.','_')

    where{ name.like(search) }
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

  def self.for_period(period)
    joins{deals.outer}.where{deals.published == true}.
    where{coalesce(deals.contract_date, deals.announcement_date) >= period.begin}.
    where{coalesce(deals.contract_date, deals.announcement_date) <= period.end}
  end

  def self.for_year(year)
    for_period(Date.new(year) .. Date.new(year).end_of_year)
  end

  def self.in_ranges(range_ids)
    range_ids = range_ids.map(&:to_i)

    query = range_ids.map do |range_id|
      range = AMOUNT_RANGES[range_id]
      "(AVG(deals.amount_usd) BETWEEN #{range.begin} AND #{range.end})"
    end.join(' OR ')

    joins{deals.outer}.having(query)
  end

  def self.in_types(types)
    where{type_id.in types}
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

  private

  def set_name
    update_column :name, actor.name if actor
  end
end
