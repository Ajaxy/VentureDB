# encoding: utf-8

class InvestorDecorator < ApplicationDecorator
  decorates :investor

  def amount
    millions investor.investments.map { |inv| inv.deal.try(:amount) || 0 }.sum
  end

  def count
    investor.investments.size
  end

  def description
    [investor.type, *investor.locations.map(&:name)].join(", ")
  end
end
