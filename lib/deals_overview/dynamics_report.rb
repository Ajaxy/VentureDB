# encoding: utf-8

class DealsOverview
  class DynamicsReport < Report
    class Quarter
      attr_reader :year, :number

      def initialize(year, number)
        @year   = year
        @number = number
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

      def includes?(deal)
        date = deal.contract_date || deal.announcement_date or return
        bounds.cover?(date)
      end
    end

    class Year
      attr_reader :year

      def initialize(year)
        @year = year
      end

      def name
        "#{year} г."
      end

      def includes?(deal)
        date = deal.contract_date || deal.announcement_date or return
        date.year == @year
      end
    end

    class PeriodSeries < Series
      attr_reader :period, :deals

      def initialize(period, deals)
        @period = period
        @deals  = deals
      end

      def name
        period.name
      end
    end

    class MainChart < BaseChart
      def extra_options
        {
          series:     with_line,
          seriesType: "bars",
        }
      end

      def title
        "Динамика венчурных сделок"
      end

      def type
        "ComboChart"
      end

      def data
        data = @series.map { |p| [ p.name, p.count, p.amount.round(1) ] }
        data.prepend ["Квартал", "Количество сделок",
                      "Объем сделок, млн долл. США"]
        data
      end

      def dom_id
        "dynamics-main-chart"
      end
    end

    class ExtraChart < BaseChart
      def extra_options
        {}
      end

      def title
        "Средняя стоимость венчурной сделки"
      end

      def type
        "ColumnChart"
      end

      def data
        data = @series.map { |p| [ p.name, p.average_amount ] }
        data.prepend ["Квартал", "Средняя стоимость сделки, млн долл. США"]
        data
      end

      def dom_id
        "dynamics-extra-chart"
      end
    end


    def initialize(deals, year = nil)
      @year = year
      super(deals)
    end

    def add_deal(deal)
      period = period_for(deal)
      @grouped_deals[period] << deal if period
    end

    def series
      @series ||=
      periods.map { |period| PeriodSeries.new(period, @grouped_deals[period]) }
    end

    def main_chart
      MainChart.new(series)
    end

    def extra_chart
      ExtraChart.new(series)
    end

    def title
      "Венчурные инвестиции по #{by_quarters? ? "кварталам" : "годам"}"
    end

    private

    def by_quarters?
      !!@year
    end

    def period_for(deal)
      periods.find { |period| period.includes?(deal) }
    end

    def periods
      @periods ||= begin
        if by_quarters?
          (1..4).map { |i| Quarter.new(@year, i) }
        else
          amount = DealFilter::LAST_YEARS
          (0...amount).map { |i| Year.new(Time.current.year - i) }.reverse
        end
      end
    end
  end
end
