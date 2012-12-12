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
        "#{Deal::STAGES[@id]} (#{count})"
      end
    end

    class Chart < BaseChart
      def data
        data = series.map { |s| [s.name, s.amount.round] }
        data.prepend ["Стадия", "Объем сделок, млн долл. США"]
        data
      end

      def dom_id
        "stages-chart"
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
        }
      end

      def type
        "BarChart"
      end
    end


    def add_deal(deal)
      id = deal.stage_id or return
      @grouped_deals[id] << deal
    end

    def series
      @series ||= Deal::STAGES.map { |id, _| Stage.new(id, @grouped_deals[id]) }
    end

    def chart
      Chart.new(series)
    end
  end
end
