# encoding: utf-8

class DealsOverview
  class Series
    def amount
      @amount ||= deals.sum(&:amount).to_f
    end

    def count
      @count ||= deals.size
    end

    def average_amount
      @average_amount ||= count == 0 ? 0 : (amount / count.to_f).round(3)
    end

    def millions
      (amount / 1_000_000).round
    end

    def as_json(*)
      {
        amount:         amount.round(1),
        count:          count,
        average_amount: average_amount.round(2)
      }
    end

    def +(other)
      self.class.new(nil, deals + other.deals)
    end
  end
end

