# encoding: utf-8

class InvestorsController < CabinetController
  def index
    search = params[:search] ? params : params[:extended_search]
    @sorter = InvestorSorter.new(params)
    @filter = decorate InvestorFilter.new(search), view: view_context,
                                                   sorter: @sorter
    scope = ViewInvestor.includes{deals}
    scope = scope.joins{deals.outer}
                 .select("view_investors.*, count(deals.id) AS deals_count ")
                 .where{deals.published == true}
                 .group{id}
                 .group{full_name}
                 .group{contacts}
                 .group{type_id}
                 .group{uniq_id}
                 .group{type}
    scope = @filter.filter(scope)
    scope = @sorter.sort(scope)
    
    @investors = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @investor = decorate Investor.find(params[:id])
    @directions = DealsOverview::DirectionsReport.new(@investor.published_deals)
  end
end
