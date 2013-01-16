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

  define_index do
    indexes "ltrim(investors.name)", as: :name, sortable: true

    where "investors.draft = 'f'"

    has scopes(:id), as: :scope_ids
    has deals(:stage_id), as: :stage_ids
    has "COUNT(deals.id)", as: :deals_count, type: :integer
  end

  sphinx_scope(:in_scope) { |scope|
    { with: { scope_ids: scope.id } }
  }

  sphinx_scope(:in_stage) { |stage|
    { with: { stage_ids: stage } }
  }

  sphinx_scope(:order_by_name) { |direction|
    { order: :name, sort_mode: direction }
  }

  sphinx_scope(:order_by_investments) {
    { order: :deals_count, sort_mode: :desc }
  }

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

  def self.order_by_type(direction)
    order("type_id #{direction}")
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

  def deals_count
    @deals_count ||= deals.published.count
  end

  private

  def set_name
    update_column :name, actor.name if actor
  end
end
