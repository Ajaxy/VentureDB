# encoding: utf-8

class DealsOverview
  MONEY_RATE = 30_000_000

  attr_reader :deals, :year
  attr_reader :totals, :dynamics, :directions, :stages, :rounds

  delegate :count, :amount, to: :totals

  def initialize(year = nil)
    if year.to_i.in?(Time.current.year - 2 .. Time.current.year)
      @year  = year.to_i
      @deals = Deal.for_year(@year)
    else
      @deals = Deal.scoped
    end

    @totals     = Totals.new(@deals)
    @directions = Directions.new(@deals, nil)
    @dynamics   = Dynamics.new(@year)
    @stages     = Stages.new(@deals)
    @rounds     = Rounds.new(@deals)
  end

  def investors
    ids = @deals.map(&:id)
    Investment.where{deal_id.in(ids)}.uniq.pluck(:investor_id).size
  end

  def projects
    @deals.map(&:project_id).uniq.length
  end
end
