# encoding: utf-8

class DealsOverview
  class TotalsReport < Series
    attr_reader :deals

    def initialize(deals)
      @deals = deals
    end

    def investors
      ids = deals.map(&:id)
      Investment.where{deal_id.in(ids)}.pluck(:investor_id).compact.uniq.size
    end

    def projects
      deals.map(&:company_id).compact.uniq.size
    end
  end
end
