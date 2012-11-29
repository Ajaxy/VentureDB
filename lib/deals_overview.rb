# encoding: utf-8

class DealsOverview
  attr_reader :filter
  delegate :count, :amount, :investors, :projects, to: :totals

  def initialize(params = {})
    @filter = DealFilter.new(params)
  end

  def deals
    @deals ||= filter.deals.includes{investments.investor.locations}
                           .includes{project.scopes}.to_a
  end

  def directions
    @directions ||= DirectionsReport.new(deals, filter.scope)
  end

  def dynamics
    @dynamics ||= DynamicsReport.new(deals, filter.year)
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
end
