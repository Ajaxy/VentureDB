# encoding: utf-8

class DynamicsChart
  class Quarter
    attr_reader :year, :number

    def initialize(year, number)
      @year = year
      @number = number
      while @number <= 0
        @year   -= 1
        @number += 4
      end
    end

    def period
      start_month = (number - 1) * 3 + 1
      end_month   = number * 3
      Date.new(year, start_month) .. Date.new(year, end_month)
    end

    def name
      "#{year}/#{number}"
    end
  end

  class Scope < Draper::Base
    decorates :scope

    attr_accessor :chart
    attr_accessor :mean

    def annual_growth
      @annual_growth ||= growth(0, -1)
    end

    def annual_growth_abs
      @annual_growth_abs ||= growth_abs(0, -1)
    end

    def quarter_growth
      @quarter_growth ||= growth(-2, -1)
    end

    def quarter_growth_abs
      @quarter_growth_abs ||= growth_abs(-2, -1)
    end

    private

    def amount_for(index)
      chart.amount_for(chart.quarters[index], self)
    end

    def growth(first_index, last_index)
      first = amount_for(first_index)
      last  = amount_for(last_index)
      return 0 if first == 0 || last == 0
      result = (last - first) / first.to_f
      percents(result)
    end

    def growth_abs(first_index, last_index)
      amount_for(last_index) - amount_for(first_index)
    end

    def percents(value)
      (value * 100).round
    end
  end

  attr_reader :means

  def initialize
    @means = []
  end

  def annual_growth
    mean.annual_growth
  end

  def quarter_growth
    mean.quarter_growth
  end

  def growers
    @growers ||= scopes.sort_by(&:quarter_growth)
  end

  def fastest_grower
    growers.last
  end

  def slowest_grower
    growers.first
  end

  def amount_for(quarter, scope)
    @amount_for ||= Hash.new
    return @amount_for[[quarter, scope]] if @amount_for[[quarter, scope]]

    total = scope.deals.select do |deal|
      deal.contract_date && quarter.period.cover?(deal.contract_date)
    end.sum { |deal| deal.amount || 0 }

    result = (total / 1_000_000.0).round
    result = (result / scopes.size.to_f).round if scope.mean

    @amount_for[[quarter, scope]] = result
  end

  def quarters
    @quarters ||= begin
      year = Time.current.year
      last_quarter = (Time.current.month - 1) / 3
      5.times.map { |i| Quarter.new(year, last_quarter - i) }.reverse
    end
  end

  def data
    get_data.to_json
  end

  def mean
    @mean ||= begin
      scope = Scope.decorate OpenStruct.new(deals: scopes.sum(&:deals))
      scope.chart = self
      scope.mean  = true
      scope
    end
  end

  def options
    {
      vAxis:      { title: "Миллионы руб." },
      hAxis:      { title: "Квартал" },
      seriesType: "bars",
      series:     { scopes.length => { type: "line" } },
    }.to_json
  end

  def scopes
    @scopes ||= ::Scope.roots.map do |scope|
      scope = Scope.decorate(scope)
      scope.chart = self
      scope
    end.select { |s| s.deals.any? }.sort_by(&:name)
  end

  def title
    "Динамика роста по сферам деятельности"
  end

  def type
    "ComboChart"
  end

  private

  def get_data
    data = quarters.map do |quarter|
      values = (scopes + [mean]).map { |scope| amount_for(quarter, scope) }
      [ quarter.name, *values ]
    end

    data.prepend ["Квартал", *scopes.map(&:name), "Среднее"]
    data
  end
end
