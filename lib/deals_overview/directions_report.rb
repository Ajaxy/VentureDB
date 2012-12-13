# encoding: utf-8

class DealsOverview
  class DirectionsReport < Report
    class Scope < Series
      attr_reader :scope, :deals

      def initialize(scope, deals)
        @deals = deals
        @scope = scope
      end

      def for_stage(id)
        stages.data_for(id)
      end

      def name
        scope.short_name
      end

      private

      def stages
        @stages ||= StagesReport.new(deals)
      end
    end


    def initialize(deals, scope = nil)
      @scope = scope
      super(deals)
    end

    def add_deal(deal)
      scopes = deal.project.try(:scopes) or return

      scopes.each do |scope|
        scope = find_scope_for(scope)
        @grouped_deals[scope] << deal if scope
      end
    end

    def deals_for(scope)
      @grouped_deals[scope].uniq
    end

    def series
      @series ||= begin
        scopes = @grouped_deals.map { |scope, deals| Scope.new(scope, deals) }
        scopes.select { |s| s.amount > 0 }.sort_by(&:amount).reverse
      end
    end

    private

    def find_scope_for(scope)
      if scope.in?(@scope, *scopes)
        scope
      else
        scopes.find { |root| scope.is_descendant_of?(root) }
      end
    end

    def scopes
      @scopes ||= @scope ? @scope.children.to_a : ::Scope.roots.to_a
    end
  end
end
