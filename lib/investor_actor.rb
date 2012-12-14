# encoding: utf-8

module InvestorActor
  extend ActiveSupport::Concern

  included do
    has_many :investors, as: :actor
    has_many :investments, through: :investors

    after_save :set_investor_name
  end

  def set_investor_name
    investors(true).each { |inv| inv.update_column :name, name }
  end

  module ClassMethods
  end
end
