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
    end

    def initialize(deals, id)
      # @deals = select(deals)
      @deals = deals
      @id    = id
    end

    def series
      # scopes = id ? current_scope.children : ::Scope.roots
      ::Scope.roots.map { |scope| Scope.new(scope, @deals) }
    end

    private

    # def current_scope
    #   scope = ::Scope.find(id)
    #   raise ArgumentError.new if scope.leaf?
    #   scope
    # end

    # def select(deals)
    #   return deals unless @id
    #   scopes.map { |scope| deals.in_scope(scope) }.sum

    #   deals.select do |deal|
    #     deal.project.scopes.find { |scope| covers? scope, scopes }
    #   end
    # end
  end
end
