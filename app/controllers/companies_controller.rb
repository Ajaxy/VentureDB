# encoding: utf-8

class CompaniesController < CabinetController
  def index
    search = params[:search] ? params : params[:extended_search]
    @sorter = CompanySorter.new(params)
    @filter = decorate CompanyFilter.new(search), view: view_context,
                                                   sorter: @sorter

    scope = Company.infrastructure.published
    scope = @filter.filter(scope)
    scope = @sorter.sort(scope)

    @companies = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @company = decorate Company.find(params[:id])
    @deals   = decorate @company.deals.order_by_started_at(:desc)
    @to_connections = decorate @company.to_connections
    @from_connections = decorate @company.from_connections
  end
end
