# encoding: utf-8

class ProjectsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter   = ProjectSorter.new(params, view_context)
    scope     = paginate Project.published.includes{[company, scopes, authors]}
    @projects = decorate @sorter.sort(scope)
  end

  def show
    @project = decorate Project.find(params[:id])
  end
end
