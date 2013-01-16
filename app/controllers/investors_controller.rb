# encoding: utf-8

class InvestorsController < CabinetController
  def index
    @sorter = InvestorSorter.new(params)
    @filter = decorate InvestorFilter.new(params), view: view_context,
                                                   sorter: @sorter

    scope = Investor.search
    scope = @filter.filter(scope)
    scope = @sorter.sort(scope)

    @investors = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @investor = decorate Investor.find(params[:id])
    @directions = DealsOverview::DirectionsReport.new(@investor.published_deals)
  end
end
