# encoding: utf-8

class ProjectsController < CabinetController
  def index
    search = params[:search] ? params : params[:extended_search]
    scope = Company.innovation.published
    @filter = decorate ProjectFilter.new(search), view: view_context

    scope = @filter.filter(scope)

    @projects = PaginatingDecorator.decorate paginate(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
