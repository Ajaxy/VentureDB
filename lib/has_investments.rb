# encoding: utf-8

module HasInvestments
  def investments_amount
    @investments_amount ||= published_deals.sum(&:amount)
  end

  def investments_count
    @investments_count ||= published_deals.size
  end

  def published_deals
    @published_deals ||= deals.select(&:published).sort_by(&:date).reverse
  end
end
