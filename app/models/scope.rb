# encoding: utf-8

class Scope < ActiveRecord::Base
  acts_as_nested_set

  attr_accessor :deals

  def short_name
    self[:short_name] || name
  end

  def amount
    deals.sum { |deal| deal.amount || 0 }
  end

  def count
    deals.size
  end
end
