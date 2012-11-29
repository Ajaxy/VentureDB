# encoding: utf-8

class DealsOverview
  class DirectionsReport < Report
    class Scope < Series
      attr_reader :scope, :deals

      def initialize(scope, deals)
        @deals = deals
        @scope = scope
      end

      def name
        scope.short_name
      end
    end


    def initialize(deals, id = nil)
      @id = id
      super(deals)
    end

    def add_deal(deal)
      scopes = deal.project.try(:scopes) or return

      scopes.each do |scope|
        scope = find_scope_for(scope)
        @grouped_deals[scope] << deal
      end
    end

    def series
      @series ||= begin
        scopes = @grouped_deals.map { |scope, deals| Scope.new(scope, deals) }
        scopes.select { |s| s.amount > 0 }.sort_by(&:amount).reverse
      end
    end

    private

    def find_scope_for(scope)
      if scope.root?
        scope
      else
        @roots ||= ::Scope.roots
        @roots.find { |root| scope.is_descendant_of?(root) }
      end
    end
  end
end
