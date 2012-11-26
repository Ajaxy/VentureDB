# encoding: utf-8

class DealsOverview
  class Stages
    class Stage < ChartEntry
      def initialize(id, deals)
        @id     = id
        @deals  = deals
      end

      def name
        "#{Deal::STAGES[@id]} (#{count})"
      end

      private

      def deals
        @deals.where(stage_id: @id)
      end
    end

    def initialize(deals)
      @deals = deals
    end

    def stages
      Deal::STAGES.keys.map { |id| Stage.new(id, @deals) }
                      .select { |s| s.count > 0 }
    end
  end
end
