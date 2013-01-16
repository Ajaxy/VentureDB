# encoding: utf-8

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

  define_index do
    indexes "ltrim(projects.name)", as: :name, sortable: true
    indexes description
    indexes company.name
    indexes authors.first_name
    indexes authors.last_name

    where "projects.draft = 'f'"

    has scopes(:id), as: :scope_ids
    has deals(:round_id), as: :round_ids
    has "SUM(DISTINCT deals.amount_usd)", as: :total_amount, type: :integer
  end

  sphinx_scope(:in_scope) { |scope|
    { with: { scope_ids: scope.id } }
  }

  sphinx_scope(:in_round) { |round|
    { with: { round_ids: round } }
  }

  sphinx_scope(:order_by_name) { |direction|
    { order: :name, sort_mode: direction }
  }

  sphinx_scope(:order_by_investments) {
    { order: :total_amount, sort_mode: :desc }
  }

  def self.suggest(string)
    return scoped unless string.present?
    search = "%#{string}%".gsub('.','_')

    where{ name.like(search) }
  end

  def self.in_scope(scope)
    joins{scopes.outer}.where{(scopes.lft >= scope.lft) & (scopes.lft < scope.rgt)}
  end

  def self.in_round(round)
    joins{deals.outer}.where{(deals.round_id == round) & (deals.published == true)}
  end

  def publish
    super
    authors.each(&:publish)
    company.try(:publish)
  end

  def deals_amount
    @deals_amount ||= deals.published.sum(:amount_usd)
  end
end
