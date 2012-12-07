# encoding: utf-8

class Admin::DealsController < Admin::BaseController
  before_filter :find_deal, only: [:show, :edit, :update, :destroy,
                                   :publish, :unpublish]

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

    if @deal.save && @deal.undraft
      redirect_to [:admin, @deal], notice: "Сделка успешно добавлена."
    else
      render :new
    end
  end

  def edit
  end

  def update
    raise_404 if @deal.published?

    if @deal.update_attributes(permitted_params.deal) && @deal.undraft
      redirect_to [:admin, @deal], notice: "Сделка успешно обновлена."
    else
      render :edit
    end
  end

  def publish
    if @deal.publish
      redirect_to [:admin, @deal]
    else
      flash.now.alert = @deal.errors[:publish].join("<br>").html_safe
      render :edit
    end
  end

  def unpublish
    @deal.unpublish
    redirect_to [:admin, @deal]
  end

  private

  def find_deal
    @deal = Deal.find(params[:id])
  end
end
