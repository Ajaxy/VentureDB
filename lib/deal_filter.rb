# encoding: utf-8

class DealFilter
  LAST_YEARS = 3

  attr_reader :params

  def initialize(params)
    @params = OpenStruct.new(params)
  end

  def filter(deals)
    deals = deals.in_stage(params.stage.to_i)
    deals = deals.in_round(params.round.to_i)
    deals = deals.with_investor_type(params.investor.to_i)

    deals = deals.for_year(year)              if year
    deals = deals.in_scope(scope)             if scope
    deals = deals.from_date(date_start)       if date_start
    deals = deals.to_date(date_end)           if date_end
    deals = deals.from_amount(amount_start)   if amount_start
    deals = deals.to_amount(amount_end)       if amount_end
    deals = deals.search(params.search.strip) if params.search.present?

    deals
  end

  def deals
    filter(Deal.scoped)
  end

  def amount(string)
    return unless string.present?

    string.gsub!(/[  ]/, "")
    string.sub!(",", ".")
    (string.to_f * 1_000_000).round
  end

  def amount_start
    amount(params.amount_start)
  end

  def amount_end
    amount(params.amount_end)
  end

  def date(string)
    return unless string.present?

    d, m, y = string.split(".")
    date = Date.new(y.to_i, m.to_i, d.to_i) rescue nil

    range = (Date.today - 100.years .. Date.today + 100.years)
    date if date && range.cover?(date)
  end

  def date_start
    date = date(params.date_start)
    params.date_start = nil unless date
    date
  end

  def date_end
    date = date(params.date_end)
    params.date_end = nil unless date
    date
  end

  def scope
    Scope.where(id: params.scope.to_i).first if params.scope.present?
  end

  def year
    year = params.year.to_i
    year if year.in?(Time.current.year - LAST_YEARS + 1 .. Time.current.year)
  end
end
