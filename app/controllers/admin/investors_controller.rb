# encoding: utf-8

class Admin::InvestorsController < Admin::BaseController
  before_filter :find_investor, only: [:show, :edit, :update]

  def index
    @sorter    = InvestorSorter.new(params, view_context)
    scope      = @sorter.sort(Investor.published.with_actor)
    @investors = PaginatingDecorator.decorate paginate(scope)
  end

  def create
    @investor = InvestorForm.new(params[:investor])

    if @investor.save
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
    if @investor.update_attributes(permitted_params.investor)
      redirect_to [:admin, @investor], notice: "Информация сохранена"
    else
      render :edit
    end
  end

  private

  def find_investor
    @investor = Investor.find(params[:id])
  end
end
