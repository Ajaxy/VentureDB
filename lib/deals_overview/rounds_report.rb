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
        @series = series.select(&:name)
      end

      def data
        data = @series.map { |r| [r.name, r.count, r.amount.round] }
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
      @grouped_deals[deal.round_id] << deal
    end

    def data_for(id)
      series.fetch(id.to_i)
    end

    def series
      @series ||= begin
        ids = [nil, *Deal::ROUNDS.keys]
        ids.map { |id| Round.new(id, @grouped_deals[id]) }
      end
    end

    def chart
      Chart.new(series)
    end
  end
end
