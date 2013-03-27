# encoding: utf-8

class InvestorFilter < Filter
  def filter(investors)
    investors = investors.search(search)  if search
    investors = investors.in_scopes(params.sector) if params.sector
    investors = investors.in_types(params.investor_type) if params.investor_type
    investors = investors.for_year(current_year) if params.for_current_year == '1'
    investors = investors.in_ranges(params.avg_deal_amount) if params.avg_deal_amount
    investors
  end

  def current_year
    Time.zone.now.year
  end
end
