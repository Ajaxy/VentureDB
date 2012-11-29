# encoding: utf-8

class DealsOverview
  class Series
    def amount
      @amount ||= begin
        sum = deals.sum(&:amount_in_dollars)
        (sum.to_f / 1_000_000.0).round(@precision || 0)
      end
    end

    def count
      @count ||= deals.size
    end

    def average_amount
      @average_amount ||= count == 0 ? 0 : (amount / count.to_f).round(3)
    end
  end
end
