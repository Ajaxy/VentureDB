# encoding: utf-8

class DealsOverview
  class Locations
    class Location < Series
      attr_reader :location, :deals
      delegate :name, :x, :y, to: :location

      def initialize(location, deals)
        @location  = location
        @deals     = deals
      end
    end


    def initialize(deals)
      @deals_by_country = group_by_country(deals)
    end

    def series
      @series ||= begin
        locs = @deals_by_country.map { |loc, deals| Location.new(loc, deals) }
        locs.select { |loc| loc.amount > 0 }.sort_by(&:amount).reverse
      end
    end

    def data
      series.map { |loc| [loc.name, loc.count, loc.amount, loc.x, loc.y ] }
    end

    private

    def group_by_country(deals)
      hash = Hash.new { |h, k| h[k] = [] }

      deals.each do |deal|
        locs = deal.investments.map { |i| i.investor.locations }.reduce(:+)
        next unless locs

        locs.each do |location|
          country = find_country_for(location)
          hash[country] << deal
        end
      end

      hash
    end

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
