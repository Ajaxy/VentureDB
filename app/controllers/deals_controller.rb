# encoding: utf-8

class DealsController < ApplicationController
  before_filter :require_admin!, except: %w[index show]

  def index
    @deals = decorate Deal.includes(:project, :investors => :actor)
                          .page(params[:page]).per(50).order{id.desc}
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
