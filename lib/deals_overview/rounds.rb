# encoding: utf-8

class DealsOverview
  class Rounds
    class Round < Series
      def initialize(id, deals)
        @id         = id
        @all_deals  = deals
      end

      def name
        Deal::ROUNDS[@id]
      end

      def deals
        @deals ||= @all_deals.where(round_id: @id).to_a
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


    def initialize(deals)
      @deals = deals
    end

    def chart
      Chart.new(series)
    end

    def series
      Deal::ROUNDS.keys.map { |id| Round.new(id, @deals) }
                       .select { |s| s.count > 0 }
    end

    def chart
      Chart.new(series)
    end
  end
end
