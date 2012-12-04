# encoding: utf-8

class DealsOverview
  class Series
    def amount
      @amount ||= begin
        sum = deals.sum(&:amount_in_dollars)
        sum.to_f / 1_000_000.0
      end
    end

    def amount_string(precision = 1)
      @amount_string ||= "$#{amount.round(precision)}M"
    end

    def count
      @count ||= deals.size
    end

    def average_amount
      @average_amount ||= count == 0 ? 0 : (amount / count.to_f).round(3)
    end

    def average_amount_string
      @average_amount_string ||= "$#{average_amount.round(2)}M"
    end

    def as_json(*)
      {
        amount:         amount.round(1),
        count:          count,
        average_amount: average_amount.round(1)
      }
    end

    def +(other)
      self.class.new(nil, deals + other.deals)
    end
  end
end

