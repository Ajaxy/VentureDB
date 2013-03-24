# encoding: utf-8

class HasInvestmentsDecorator < ApplicationDecorator
  def deals_amount
    model.deals_amount.to_i
  end

  def deals_count
    model.deals_count.to_i
  end

  def deal_string(count = self.count)
    strcount = count.to_s
    return strcount + ' сделок' if (strcount.length > 1) and (strcount[-2] == '1')
    case strcount[strcount.length-1]
    when '1'
      return strcount + ' сделка'
    when '2','3','4'
      return strcount + ' сделки'
    else
      return strcount + ' сделок'
    end
  end

  def amount
    deals_amount == 0 ? mdash : dollars(deals_amount)
  end

  def count
    deals_count == 0 ? mdash : deals_count
  end

  def average_deal_amount
    dollars source.average_deal_amount.to_i
  end
end
