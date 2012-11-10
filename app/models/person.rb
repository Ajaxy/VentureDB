# encoding: utf-8

class Person < ActiveRecord::Base
  has_one :user

  has_many :investors, as: :actor
  has_many :investments, through: :investors

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings
end
