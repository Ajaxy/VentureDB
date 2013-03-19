# encoding: utf-8

class DealsController < CabinetController
  def index
    search  = params[:search] ? params : params[:extended_search]
    @filter = decorate DealFilter.new(search), view: view_context

    scope   = Deal.published.includes{[company.scopes.parent,
                                       investors.actor, investors.locations]}
    scope   = @filter.filter(scope)

    @deals  = PaginatingDecorator.decorate(paginate scope)
  end

  def show
    @deal = decorate Deal.find(params[:id])
  end
end
