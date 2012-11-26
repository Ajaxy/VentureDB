# encoding: utf-8

class DealsOverview
  class Stages
    class Stage < Series
      def initialize(id, deals)
        @id         = id
        @all_deals  = deals
      end

      def name
        "#{Deal::STAGES[@id]} (#{count})"
      end

      def deals
        @deals ||= @all_deals.where(stage_id: @id).to_a
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


    def initialize(deals)
      @deals = deals
    end

    def series
      Deal::STAGES.keys.map { |id| Stage.new(id, @deals) }
                       .select { |s| s.count > 0 }
    end

    def chart
      Chart.new(series)
    end
  end
end
