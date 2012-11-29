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

    class Chart
      def initialize(series)
        @series = series
      end

      def data
        data = @series.map { |stage| [stage.name, stage.amount] }
        data.prepend ["Стадия", "Сумма сделок"]
        data
      end

      def dom_id
        "stages-chart"
      end

      def title
        "Объем инвестирования и количество сделок по стадиям проекта"
      end

      def options
        {
          title:  title,
          hAxis:  { title: "Миллионы $" },
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
      @series ||= begin
        stages = @grouped_deals.map { |id, deals| Stage.new(id, deals) }
        stages.select { |stage| stage.count > 0 }
      end
    end

    def chart
      Chart.new(series)
    end
  end
end
