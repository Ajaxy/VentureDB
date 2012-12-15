# encoding: utf-8

class InvestorFilter < Filter
  def filter(investors)
    investors = investors.search(search)  if search
    investors = investors.in_round(round) if round
    investors = investors.in_scope(scope) if scope
    investors = investors.in_stage(stage) if stage
    investors
  end
end
