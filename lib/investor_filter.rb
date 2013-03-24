# encoding: utf-8

class InvestorFilter < Filter
  def filter(investors)
    investors = investors.search(search)  if search
    investors = investors.in_scopes(params.sector) if params.sector
    investors = investors.in_rounds(params.round) if params.round
    investors = investors.in_types(params.investor_type) if params.investor_type
    investors = investors.in_types(params.deal_type) if params.deal_type
    investors = investors.for_year(current_year) if params.for_current_year == '1'
    investors
  end

  def current_year
    Time.zone.now.year
  end
end
