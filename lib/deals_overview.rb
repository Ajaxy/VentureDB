# encoding: utf-8

class DealsOverview
  attr_reader :filter

  delegate :deals, :year, :scope, to: :filter
  delegate :count, :amount, :investors, :projects, to: :totals

  def initialize(params = {})
    @filter = DealFilter.new(params)
  end

  def directions
    Directions.new(deals, scope)
  end

  def dynamics
    Dynamics.new(deals, year)
  end

  def rounds
    Rounds.new(deals)
  end

  def stages
    Stages.new(deals)
  end

  def totals
    Totals.new(deals)
  end
end
