# encoding: utf-8

class Admin::InvestorsController < Admin::BaseController
  before_filter :find_investor, only: [:show, :edit, :update, :destroy]

  def index
    @sorter    = InvestorSorter.new(params, view_context)
    scope      = @sorter.sort(Investor.published.with_actor)
    @investors = PaginatingDecorator.decorate paginate(scope)
  end

  def new
    @investor = Investor.new
  end

  def create
    @investor = InvestorForm.new(params[:investor])

    if @investor.save
      redirect_to [:admin, @investor.investor], notice: "Инвестор успешно добавлен."
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

  def destroy
    @investor.destroy
    redirect_to [:investors], notice: 'Ивестор удалён.'
  end

  private

  def find_investor
    @investor = Investor.find(params[:id])
  end
end
