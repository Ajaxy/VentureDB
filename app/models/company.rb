# encoding: utf-8

class Company < ActiveRecord::Base
  include Trackable

  has_many :users
  has_many :projects

  has_many :investors, as: :actor
  has_many :investments, through: :investors

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings

  validates :name, presence: true

  def self.find_or_create(params, user)
    if company = where(params.slice(:name)).first
      company
    else
      create_tracking_user(user, params)
    end
  end
end
