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
      locs = deal.investments.map { |inv| inv.locations }.reduce(:+)
      return unless locs

      locs.each do |location|
        country = find_country_for(location)
        @grouped_deals[country] << deal
      end
    end

    def series
      @series ||= begin
        locs = @grouped_deals.map { |loc, deals| Location.new(loc, deals) }
        locs.select { |l| l.amount.round > 0 && l.x }.sort_by(&:amount).reverse
      end
    end

    def data
      SeriesDecorator.decorate(series).map do |l|
        [l.name, l.count, l.amount, l.amount_string, l.x, l.y ]
      end
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
