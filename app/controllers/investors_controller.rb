# encoding: utf-8

class InvestorsController < CabinetController
  def index
    @sorter     = InvestorSorter.new(params)
    @filter     = decorate InvestorFilter.new(params), view: view_context,
                                                       sorter: @sorter

    scope       = Investor.published.with_actor.includes{investments.deal}
    scope       = @sorter.sort(scope)
    scope       = @filter.filter(scope).uniq

    @investors  = decorate paginate(scope)
  end

  def show
    @investor = decorate Investor.find(params[:id])
  end
end
