# encoding: utf-8

class ProjectsController < CabinetController
  def index
    search = params[:search] ? params : params[:extended_search]
    scope = Company.innovation.published
    @filter = decorate ProjectFilter.new(search), view: view_context
    @sorter = ProjectSorter.new(params)

    scope = @filter.filter(scope)
    scope = @sorter.sort(scope)

    @projects = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
