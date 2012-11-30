# encoding: utf-8

class DealsOverview
  class GeographyReport < Report
    class Location < Series
      attr_reader :location, :deals
      delegate :name, :x, :y, to: :location

      def initialize(location, deals)
        @location  = location
        @deals     = deals
      end
    end


    def add_deal(deal)
      locs = deal.investments.map { |i| i.investor.locations }.reduce(:+)
      return unless locs

      locs.each do |location|
        country = find_country_for(location)
        @grouped_deals[country] << deal
      end
    end

    def series
      @series ||= begin
        locs = @grouped_deals.map { |loc, deals| Location.new(loc, deals) }
        locs.select { |loc| loc.amount.round > 0 }.sort_by(&:amount).reverse
      end
    end

    def data
      series.map { |l| [l.name, l.count, l.amount.round, l.x, l.y ] }
    end

    private

    def find_country_for(location)
      if location.root?
        location
      else
        @countries ||= ::Location.roots
        @countries.find { |root| location.is_descendant_of?(root) }
      end
    end
  end
end
