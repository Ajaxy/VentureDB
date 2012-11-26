# encoding: utf-8

class DealsOverview
  class Totals < ChartEntry
    attr_reader :deals

    def initialize(deals)
      @deals = deals
    end
  end
end
