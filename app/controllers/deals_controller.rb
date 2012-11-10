# encoding: utf-8

class DealsController < ApplicationController
  def index
    @deals = Deal.includes(:project).page(params[:page]).per(50)
  end

  def show
    @deal = Deal.find(params[:id])
    render :edit
  end

  def new
    @deal = Deal.new
  end

  def edit
    @deal = Deal.find(params[:id])
  end
end
