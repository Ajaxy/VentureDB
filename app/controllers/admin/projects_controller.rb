# encoding: utf-8

class Admin::ProjectsController < ApplicationController
  layout "admin"

  before_filter :authenticate_user!
  before_filter :require_admin!, except: %w[index show]
  before_filter :find_project, only: [:show, :edit, :update, :destroy]

  def index
    @sorter   = ProjectSorter.new(params, view_context)
    scope     = paginate Project.published.includes{[company, scopes, authors]}
    @projects = decorate @sorter.sort(scope)
  end

  def create
    @project = Project.new_draft(permitted_params.project)

    if @project.save
      render :success
    else
      render :error
    end
  end

  def show
    render :edit
  end

  def edit
  end

  def update
    if @project.update_attributes(permitted_params.project)
      redirect_to :projects
    else
      render :edit
    end
  end

  private

  def find_project
    @project = Project.find(params[:id])
  end
end
