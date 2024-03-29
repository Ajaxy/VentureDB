# encoding: utf-8

# deprecated
class Project < ActiveRecord::Base
  include Draftable
  include HasInvestments

  has_many :project_authors
  has_many :authors, through: :project_authors

  has_many :project_scopes
  has_many :scopes, through: :project_scopes

  has_many :location_bindings, as: :entity
  has_many :markets, through: :location_bindings, source: :location

  has_many :deals
  has_many :investments, through: :deals
  has_many :investors, through: :investments

  belongs_to :company

  validates :name, presence: true, uniqueness: true
  # validates :name, :description, :scope_ids, :market_ids, :author_ids,
  #           :presence => true

  accepts_nested_attributes_for :company

  define_index "projects_index" do
    indexes "ltrim(projects.name)", as: :name
    indexes description
    indexes company.name
    indexes authors.first_name
    indexes authors.last_name

    where "projects.draft = 'f'"
  end

  define_index "projects_prefix_index" do
    indexes "ltrim(projects.name)", as: :name
    indexes description
    indexes company.name
    indexes authors.first_name
    indexes authors.last_name

    where "projects.draft = 'f'"
    set_property min_prefix_len: 3
  end

  include Searchable

  def self.suggest(string)
    return scoped unless string.present?
    search = "%#{string}%".gsub('.','_')

    where{ name.like(search) }
  end

  def self.in_scope(scope)
    joins{scopes.outer}.where{(scopes.lft >= scope.lft) & (scopes.lft < scope.rgt)}
  end

  def self.in_scopes(scope_arr)
    joins{scopes}.where{scopes.id.in scope_arr}.group{scopes.id}.
      where{deals.published == true}
  end

  def self.in_round(round)
    joins{deals.outer}.where{deals.round_id == round}.
      where{deals.published == true}
  end

  def self.in_rounds(rounds)
    joins{deals.outer}.where{(deals.round_id.in rounds) & (deals.published == true)}
  end

  def self.in_stage(stage)
    joins{deals.outer}.where{deals.stage_id == stage}.
      where{deals.published == true}
  end

  def self.in_stages(stages)
    joins{deals.outer}.where{(deals.stage_id.in stages) & (deals.published == true)}
  end

  def self.in_amount_range(from, to)
    joins{deals.outer}.group{id}.
      where{deals.published == true}.
      where{(deals.amount_usd >= from) & (deals.amount_usd <= to)}
  end

  def self.from_amount(value)
    joins{deals.outer}.group{id}.
      where{deals.published == true}.
      having{sum(deals.amount_usd) > value}
  end

  def self.to_amount(value)
    joins{deals.outer}.group{id}.
      where{deals.published == true}.
      having{sum(deals.amount_usd) < value}
  end

  def self.for_type(type)
    ids = Investment::GRANT_INSTRUMENTS

    case type
    when "grants"
      joins{investments}.where{investments.instrument_id.in ids}
    when "investments"
      joins{investments}.where{coalesce(investments.instrument_id, 0).not_in ids}
    else
      raise ArgumentError
    end
  end

  def self.sort_type(type)
    case type
    when '2'
      order_by_investments
    else
      order_by_name('ASC')
    end
  end

  def self.order_by_name(direction)
    order("projects.name #{direction}")
  end

  def self.order_by_investments
    joins{deals.outer}.
      where{deals.published == true}.
      group{id}.
      order("sum(deals.amount_usd) desc nulls last")
  end

  def publish
    super
    authors.each(&:publish)
    company.try(:publish)
  end

  def deals_count
    deals.count
  end

  # TODO: replace with #authors. Need to keep authors association for now
  def authors_through_connections
    if company.nil?
      []
    else
      company.from_connections.joins(:connection_type).
        where(connection_types: { name: 'author' }).map(&:to)
    end
  end
end
