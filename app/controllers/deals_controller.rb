# encoding: utf-8

class DealsController < ApplicationController
  before_filter :require_admin!, except: %w[index show]
  before_filter :find_deal, only: [:show, :edit, :update, :destroy]

  def index
    @deals = decorate Deal.includes(:project, :investors => :actor)
                          .page(params[:page]).per(50).order{id.desc}
  end

  def show
    render :edit
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])

    if @deal.save
      redirect_to :deals, notice: "Сделка успешно добавлена."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @deal.update_attributes(params[:deal])
      redirect_to :deals, notice: "Сделка успешно обновлена."
    else
      render :edit
    end
  end

  private

  def find_deal
    @deal = Deal.find(params[:id])
  end
end
