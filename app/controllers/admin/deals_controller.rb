# encoding: utf-8

class Admin::DealsController < Admin::BaseController
  before_filter :find_deal, only: [:show, :edit, :update, :destroy]

  def index
    @sorter = DealSorter.new(params, view_context)
    scope   = paginate Deal.includes{[project, investors.actor]}
    @deals  = decorate @sorter.sort(scope)
  end

  def show
    render :edit
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(permitted_params.deal)

    if @deal.save && @deal.publish
      redirect_to :deals, notice: "Сделка успешно добавлена."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @deal.update_attributes(permitted_params.deal) && @deal.publish
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
