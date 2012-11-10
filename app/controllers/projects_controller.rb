# encoding: utf-8

class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:company).page(params[:page]).per(50)
  end

  def show
    @project = Project.find(params[:id])
    render :edit
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end
end
