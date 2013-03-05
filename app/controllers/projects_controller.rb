# encoding: utf-8

class ProjectsController < CabinetController
  def index
    search = params[:search] ? params : params[:extended_search]
    @filter = decorate ProjectFilter.new(search), view: view_context

    scope = Project.published.includes{[company, scopes, authors, deals]}
    scope = scope.joins{deals.outer}
                 .select("projects.*, sum(deals.amount_usd) AS deals_amount")
                 .where{deals.published == true}
                 .group{companies.id}
                 .group{id}
                 .group{people.id}
                 .group{deals.id}
                 .group{scopes.id}


    scope = @filter.filter(scope)

    @projects = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
