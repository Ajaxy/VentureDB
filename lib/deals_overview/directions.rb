# encoding: utf-8

class DealsOverview
  class Directions
    class Scope < Series
      attr_reader :scope

      def initialize(scope, deals)
        @all_deals = deals
        @scope     = scope
      end

      def deals
        @deals ||= @all_deals.in_scope(scope).to_a
      end

      def name
        scope.short_name
      end
    end

    def initialize(deals, id = nil)
      @deals = deals
      @id    = id
    end

    def series
      scopes = ::Scope.roots.map { |scope| Scope.new(scope, @deals) }
      scopes.select { |s| s.amount > 0 }.sort_by(&:amount).reverse
    end
  end
end
