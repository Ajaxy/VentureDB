# encoding: utf-8

class DealsOverview
  class Dynamics
    class Quarter < ChartEntry
      attr_reader :year, :number

      def initialize(year, number)
        @year   = year
        @number = number
      end

      def name
        "#{number} кв."
      end

      private

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
        Deal.for_period(bounds)
      end
    end

    class Year < ChartEntry
      attr_reader :year

      def initialize(year)
        @year = year
      end

      def name
        "#{year} г."
      end

      private

      def deals
        Deal.for_year(year)
      end
    end


    def initialize(year = nil)
      @year  = year
    end

    def data
      get_data.to_json
    end

    def options
      {
        vAxis:      { title: "Миллионы руб." },
        hAxis:      { title: "Квартал" },
        seriesType: "bars",
        series:     { 1 => { type: "line", pointSize: 10 } },
      }.to_json
    end

    def periods
      if @year
        (1..4).map { |i| Quarter.new(@year, i) }
      else
        (0..2).map { |i| Year.new(Time.current.year - i) }.reverse
      end
    end

    def title
      "Динамика роста по сферам деятельности"
    end

    def type
      "ComboChart"
    end

    private

    def get_data
      data = periods.map { |period| [ period.name, period.count, period.amount ] }
      data.prepend ["Квартал", "Количество сделок", "Объем сделок"]
      data
    end
  end
end
