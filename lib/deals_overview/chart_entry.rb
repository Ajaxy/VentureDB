# encoding: utf-8

class DealsOverview
  class ChartEntry
    def amount
      sum = deals.sum { |deal| deal.amount || 0 }
      (sum.to_f / MONEY_RATE).round
    end

    def count
      deals.size
    end

    def average_amount
      return 0 if count == 0
      (amount / count.to_f).round
    end
  end
end
