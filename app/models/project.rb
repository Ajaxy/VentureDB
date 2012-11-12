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

  validates :name, uniqueness: true
  validates :name, :description, :scope_ids, :market_ids, :author_ids, presence: true

  accepts_nested_attributes_for :company

  def publish
    super
    authors.each(&:publish)
    company.try(:publish)
  end
end
