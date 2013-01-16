# encoding: utf-8

class DealsController < CabinetController
  def index
    @sorter = DealSorter.new(params, view_context, default: :date)
    @filter = decorate DealFilter.new(params), view: view_context,
                                               sorter: @sorter
    scope   = Deal.search(
      include: [ project: [:authors, scopes: [:parent]], investors: [:actor, :locations] ]
    )
    scope   = paginate @sorter.sort(scope)
    scope   = @filter.filter(scope)

    @deals  = PaginatingDecorator.decorate(paginate scope)
  end

  def show
    @deal = decorate Deal.find(params[:id])
  end
end
