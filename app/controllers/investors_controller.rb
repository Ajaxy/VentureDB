# encoding: utf-8

class InvestorsController < CabinetController
  def index
    search = params[:search] ? params : params[:extended_search]
    @sorter = InvestorSorter.new(params, view_context)
    @filter = decorate InvestorFilter.new(search), view: view_context,
                                                   sorter: @sorter

    scope = Investor.published.with_actor.includes{deals}
    scope = scope.joins{deals.outer}
                 .select("investors.*, count(deals.id) AS deals_count, avg(deals.amount_usd) AS average_deal_amount")
                 .where{deals.published == true}
                 .group{id}

    scope = @filter.filter(scope)
    scope = @sorter.sort(scope)

    @investors = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @investor = Investor.find(params[:id])
    redirect_to url_for(@investor.actor)
  end
end
