# encoding: utf-8

class Project < ActiveRecord::Base
  include Draftable

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

  def self.search(string)
    return scoped unless string.present?
    search = "%#{string}%"

    joins{[ company.outer, authors.outer ]}
    .where{ name.like(search) |
            description.like(search) |
            company.name.like(search) |
            authors.first_name.like(search) |
            authors.last_name.like(search) }
  end

  def self.in_scope(scope)
    joins{scopes.outer}.where{(scopes.lft >= scope.lft) & (scopes.lft < scope.rgt)}
  end

  def self.in_round(round)
    joins{deals.outer}.where{deals.round_id == round}
  end

  def publish
    super
    authors.each(&:publish)
    company.try(:publish)
  end

  def investments_amount
    @investments_amount ||=
      deals.published.map { |deal| deal.try(:amount) || 0 }.sum
  end

  def investments_count
    @investments_count ||= deals.published.size
  end
end
