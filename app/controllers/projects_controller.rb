# encoding: utf-8

class ProjectsController < ApplicationController
  before_filter :require_admin!, except: %w[index show]
  before_filter :find_project, only: %[show edit update destroy]

  def index
    @projects = Project.includes(:company).page(params[:page]).per(50)
  end

  def create
    @project = Project.new(params[:project])

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
    if @project.update_attributes(params[:project])
      redirect_to @project
    else
      render :edit
    end
  end

  private

  def find_project
    @project = Project.find(params[:id])
  end
end
