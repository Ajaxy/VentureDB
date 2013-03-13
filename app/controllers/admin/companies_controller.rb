# encoding: utf-8

class Admin::CompaniesController < Admin::BaseController
  before_filter :find_company, only: [:show, :edit, :update]

  def index
    @sorter    = CompanySorter.new(params, view_context)
    scope      = paginate Company.infrastructure.scoped
    @companies = PaginatingDecorator.decorate @sorter.sort(scope)
  end

  def show
    render :edit
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(permitted_params.company)

    if @company.save
      redirect_to [:admin, @company], notice: "Компания успешно добавлена."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update_attributes(permitted_params.company)
      redirect_to [:admin, @company], notice: "Компания успешно обновлена."
    else
      render :edit
    end
  end

  private

  def find_company
    @company = Company.find(params[:id])
  end
end
