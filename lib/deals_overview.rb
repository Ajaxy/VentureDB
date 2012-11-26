# encoding: utf-8

class DealsOverview
  MONEY_RATE = 30_000_000

  attr_reader :totals, :dynamics, :directions, :stages, :rounds

  delegate :count, :amount, to: :totals
  delegate :deals, to: :dynamics

  def initialize(year = nil)
    @dynamics   = Dynamics.new(year)

    @totals     = Totals.new(deals)
    @directions = Directions.new(deals, nil)

    @stages     = Stages.new(deals)
    @rounds     = Rounds.new(deals)
  end

  def investors
    ids = deals.map(&:id)
    Investment.where{deal_id.in(ids)}.pluck(:investor_id).compact.uniq.size
  end

  def projects
    deals.map(&:project_id).compact.uniq.size
  end
end
