# encoding: utf-8

class ProjectsController < CabinetController
  def index
    @sorter = ProjectSorter.new(params, view_context)
    @filter = decorate ProjectFilter.new(params), view: view_context,
                                                  sorter: @sorter

    scope = Project.published.includes{[company, scopes, authors, deals]}
    scope = scope.joins{deals.outer}
                 .select("projects.*, sum(deals.amount_usd) AS deals_amount")
                 .where{deals.published == true}
                 .group{id}

    scope = @sorter.sort(scope)
    scope = @filter.filter(scope)

    @projects = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
