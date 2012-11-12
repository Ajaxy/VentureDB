# encoding: utf-8

class Project < ActiveRecord::Base
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
end