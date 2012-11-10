# encoding: utf-8

class Company < ActiveRecord::Base
  has_many :users
  has_many :projects

  has_many :investors, as: :actor
  has_many :investments, through: :investors

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings

  validates :name, presence: true
end
