# encoding: utf-8

class DealsOverview
  class Dynamics
    class Quarter < Series
      attr_reader :year, :number

      def initialize(year, number, deals)
        @year      = year
        @number    = number
        @all_deals = deals
      end

      def name
        "#{number} кв."
      end

      def bounds
        start_month = (number - 1) * 3 + 1
        end_month   = number * 3 + 1
        start_year  = year
        end_year    = year

        if end_month == 13
          end_year += 1
          end_month = 1
        end

        Date.new(start_year, start_month) ... Date.new(end_year, end_month)
      end

      def deals
        @deals ||= @all_deals.for_period(bounds)
      end
    end

    class Year < Series
      attr_reader :year

      def initialize(year, deals)
        @year      = year
        @all_deals = deals
      end

      def name
        "#{year} г."
      end

      def deals
        @deals ||= @all_deals.for_year(year)
      end
    end

    class Chart
      def initialize(series)
        @series     = series
      end

      def options
        {
          title:  title,
          vAxis:  { title: "Миллионы $" },
        }
      end
    end

    class MainChart < Chart
      def options
        super.merge(
          seriesType: "bars",
          series:     { 1 => { type: "line", pointSize: 10 } },
        )
      end

      def title
        "Динамика венчурных сделок"
      end

      def type
        "ComboChart"
      end

      def data
        data = @series.map { |period| [ period.name, period.count,
                                        period.amount ] }

        data.prepend ["Квартал", "Количество сделок", "Объем сделок"]
        data
      end

      def dom_id
        "dynamics-main-chart"
      end
    end

    class ExtraChart < Chart
      def title
        "Средняя стоимость венчурной сделки"
      end

      def type
        "ColumnChart"
      end

      def data
        data = @series.map { |period| [ period.name, period.average_amount ] }
        data.prepend ["Квартал", "Средняя стоимость сделки"]
        data
      end

      def dom_id
        "dynamics-extra-chart"
      end
    end


    def initialize(deals, year = nil)
      @deals = deals
      @year  = year
    end

    def series
      if @year
        (1..4).map { |i| Quarter.new(@year, i, @deals) }
      else
        amount = DealFilter::LAST_YEARS
        (0...amount).map { |i| Year.new(Time.current.year - i, @deals) }.reverse
      end
    end

    def main_chart
      MainChart.new(series)
    end

    def extra_chart
      ExtraChart.new(series)
    end
  end
end
