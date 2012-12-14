# encoding: utf-8

class InvestorsController < CabinetController
  def index
    @sorter     = InvestorSorter.new(params)
    @filter     = decorate InvestorFilter.new(params), view: view_context,
                                                       sorter: @sorter

    scope       = Investor.published.with_actor.includes{deals}
    scope       = @filter.filter(scope).uniq
    scope       = @sorter.sort(scope)

    @investors  = decorate paginate(scope)
  end

  def show
    @investor = decorate Investor.find(params[:id])
    @directions = DealsOverview::DirectionsReport.new(@investor.deals.published)
  end
end
