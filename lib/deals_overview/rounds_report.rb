# encoding: utf-8

class DealsOverview
  class RoundsReport < Report
    class Round < Series
      attr_reader :deals

      def initialize(id, deals)
        @id     = id
        @deals  = deals
      end

      def name
        Deal::ROUNDS[@id]
      end
    end

    class Chart
      def initialize(series)
        @series = series
      end

      def data
        data = @series.map { |round| [round.name, round.count, round.amount] }
        data.prepend ["Раунд", "Количество сделок", "Сумма сделок"]
        data
      end

      def dom_id
        "rounds-chart"
      end

      def title
        "Объем инвестирования и количество сделок по раундам инвестирования"
      end

      def options
        {
          title: title,
          vAxis:  { title: "Миллионы $" },
          seriesType: "bars",
          series:     { 1 => { type: "line", pointSize: 10 } },
        }
      end

      def type
        "ComboChart"
      end
    end


    def add_deal(deal)
      id = deal.round_id or return
      @grouped_deals[id] << deal
    end

    def series
      @series ||= begin
        rounds = @grouped_deals.map { |id, deals| Round.new(id, deals) }
        rounds.select { |round| round.count > 0 }
      end
    end

    def chart
      Chart.new(series)
    end
  end
end
