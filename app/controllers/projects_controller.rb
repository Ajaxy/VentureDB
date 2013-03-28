# encoding: utf-8

class ProjectsController < CabinetController
  def index
    search  = params[:search] ? params : params[:extended_search]
    @filter = decorate ProjectFilter.new(search), view: view_context

    scope = Company.innovation.published
    scope = scope.joins{deals.outer}
                 .select("companies.*, sum(deals.amount_usd) AS deals_sum, count(deals.id) AS deals_count")
                 .where{deals.published == true}
                 .group{id}

    scope = @filter.filter(scope)

    @projects = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
