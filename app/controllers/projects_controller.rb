# encoding: utf-8

class ProjectsController < ApplicationController
  before_filter :require_admin!, except: %w[index show]
  before_filter :find_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = decorate Project.includes(:scopes, :authors).page(params[:page])
                                .per(50).order("name")
  end

  def create
    @project = Project.new(permitted_params.project)

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
