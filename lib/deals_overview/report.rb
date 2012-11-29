# encoding: utf-8

class DealsOverview
  class Report
    def initialize(deals)
      @grouped_deals = Hash.new { |h, k| h[k] = [] }
      deals.each { |deal| add_deal(deal) }
    end
  end
end
