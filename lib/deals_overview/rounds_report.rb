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

      def short_name
        Deal::ROUNDS_SHORT[@id]
      end
    end

    class Chart < BaseChart
      def initialize(series)
        @series = SeriesDecorator.decorate series.select(&:name)
      end

      def data
        data = series.map { |r| [r.short_name, r.count, r.tooltip, r.millions, r.tooltip] }

        data.prepend([
          { type: "string", label: "Раунд" },
          { type: "number", label: "Количество сделок" },
          { type: "string", role: "tooltip", p: { html: true } },
          { type: "number", label: "Объем сделок" },
          { type: "string", role: "tooltip", p: { html: true } },
        ])

        data
      end

      def dom_id
        "rounds-chart"
      end

      def series
        @series.select { |s| s.count > 0 }
      end

      def title
        "Объем инвестирования и количество сделок по раундам инвестирования"
      end

      def extra_options
        {
          series:         with_line,
          type:           "columns",
          vAxis:          hidden_axis,
          tooltip:        { isHtml: true },
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
