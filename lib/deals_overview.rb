# encoding: utf-8

class DealsOverview
  NoDataError = Class.new(StandardError)

  attr_reader :filter, :deals, :root_directions, :directions
  delegate :scope, :year, to: :filter

  def initialize(params = {})
    @filter = DealFilter.new(params)

    @deals = @filter.by_year.includes{investments.investor.locations}
                            .includes{project.scopes}.to_a

    if scope && scope.root?
      @root_directions  = DirectionsReport.new(deals)
      @directions       = DirectionsReport.new(deals, scope)
      @deals            = @root_directions.deals_for(scope)
    else
      @root_directions  = DirectionsReport.new(deals)
      @directions       = @root_directions
    end
  end

  def dynamics
    @dynamics ||= DynamicsReport.new(deals, year)
  end

  def geography
    @geography ||= GeographyReport.new(deals)
  end

  def rounds
    @rounds ||= RoundsReport.new(deals)
  end

  def stages
    @stages ||= StagesReport.new(deals)
  end

  def totals
    @totals ||= TotalsReport.new(deals)
  end

  def summed
    @summed ||= @directions.series.reduce(:+)
  end
end
