# encoding: utf-8

class HasInvestmentsDecorator < ApplicationDecorator
  def deals_amount
    model.deals_amount.to_i
  end

  def deals_count
    model.deals_count.to_i
  end

  def amount
    deals_amount == 0 ? mdash : dollars(deals_amount)
  end

  def count
    deals_count == 0 ? mdash : deals_count
  end
end
