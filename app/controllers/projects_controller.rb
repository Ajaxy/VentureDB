# encoding: utf-8

class ProjectsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter   = ProjectSorter.new(params, view_context)
    @filter   = decorate ProjectFilter.new(params), view: view_context,
                                                    sorter: @sorter

    scope     = Project.published.includes{[company, scopes, authors, markets]}
    scope     = @sorter.sort(scope)
    scope     = @filter.filter(scope)

    @projects = decorate paginate(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
