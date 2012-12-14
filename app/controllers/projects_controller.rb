# encoding: utf-8

class ProjectsController < CabinetController
  def index
    @sorter   = ProjectSorter.new(params, view_context)
    @filter   = decorate ProjectFilter.new(params), view: view_context,
                                                    sorter: @sorter

    scope     = Project.published.includes{[company, scopes, authors, deals]}
    scope     = @sorter.sort(scope)
    scope     = @filter.filter(scope).uniq

    @projects = decorate paginate(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
