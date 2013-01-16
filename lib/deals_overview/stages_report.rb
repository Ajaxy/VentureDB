# encoding: utf-8

class DealsOverview
  class StagesReport < Report
    class Stage < Series
      attr_reader :deals

      def initialize(id, deals)
        @id     = id
        @deals  = deals
      end

      def name
        Deal::STAGES[@id]
      end
    end

    class Chart < BaseChart
      def initialize(series)
        @series = SeriesDecorator.decorate_collection series.select(&:name)
      end

      def data
        data = series.map { |s| [name(s), s.millions, s.tooltip] }

        data.prepend([
          { type: "string", label: "Стадия" },
          { type: "number", label: "Объем сделок" },
          { type: "string", role: "tooltip", p: { html: true } },
        ])

        data
      end

      def dom_id
        "stages-chart"
      end

      def name(stage)
        "#{stage.name} (#{stage.count})"
      end

      def series
        @series.select { |s| s.count > 0 }
      end

      def title
        "Объем инвестирования и количество сделок по стадиям проекта"
      end

      def extra_options
        {
          chartArea:      { width: "50%", height: "85%" },
          hAxis:          hidden_axis,
          series:         with_line,
          tooltip:        { isHtml: true },
        }
      end

      def type
        "BarChart"
      end
    end


    def add_deal(deal)
      @grouped_deals[deal.stage_id] << deal
    end

    def data_for(id)
      series.fetch(id.to_i)
    end

    def series
      @series ||= begin
        ids = [nil, *Deal::STAGES.keys]
        ids.map { |id| Stage.new(id, @grouped_deals[id]) }
      end
    end

    def chart
      Chart.new(series)
    end
  end
end
