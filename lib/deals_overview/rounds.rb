# encoding: utf-8

class DealsOverview
  class Rounds
    class Round < ChartEntry
      def initialize(id, deals)
        @id     = id
        @deals  = deals
      end

      def name
        Deal::ROUNDS[@id]
      end

      private

      def deals
        @deals.where(round_id: @id)
      end
    end

    def initialize(deals)
      @deals = deals
    end

    def rounds
      Deal::ROUNDS.keys.map { |id| Round.new(id, @deals) }
                       .select { |s| s.count > 0 }
    end
  end
end
