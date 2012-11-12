# encoding: utf-8

class Company < ActiveRecord::Base
  include Trackable

  has_many :users
  has_one :project

  has_many :investors, as: :actor
  has_many :investments, through: :investors

  validates :name, presence: true

  def self.find_or_create(params, user)
    if company = where(params.slice(:name)).first
      company
    else
      create_tracking_user(user, params)
    end
  end
end