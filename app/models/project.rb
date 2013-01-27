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

  def self.in_round(round)
    joins{deals.outer}.where{(deals.round_id == round) & (deals.published == true)}
  end

  def self.order_by_name(direction)
    order("projects.name #{direction}")
  end

  def self.order_by_investments
    joins{deals.outer}
      .select("projects.*, sum(deals.amount_usd) AS total_amount")
      .order("total_amount desc nulls last")
      .group{id}
      .where{deals.published == true}
  end

  def publish
    super
    authors.each(&:publish)
    company.try(:publish)
  end
end
