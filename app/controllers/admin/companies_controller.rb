# encoding: utf-8

class Admin::CompaniesController < Admin::BaseController
  before_filter :get_klass
  before_filter :find_company, only: [:show, :edit, :update]

  def index
    @sorter    = CompanySorter.new(params, view_context)
    scope      = paginate @klass.scoped
    @companies = PaginatingDecorator.decorate @sorter.sort(scope)
  end

  def show
    render :edit
  end

  def new
    @company = @klass.new
  end

  def create
    method = @klass.to_s.underscore.to_sym
    @company = @klass.new permitted_params.send(method)
    if @company.save
      redirect_to [:admin, @company], notice: "Компания успешно добавлена."
    else
      render :new
    end
  end

  def edit
  end

  def update
    method = @klass.to_s.underscore.to_sym
    if @company.update_attributes(permitted_params.send(method))
      redirect_to [:admin, @company], notice: "Компания успешно обновлена."
    else
      render :edit
    end
  end

  private

  def get_klass
    type = request.path.split("/")[2]
    if %[sciences infrastructures events projects investors].include? type
      @klass = type.classify.constantize
    else
      @klass = Company
    end
  end

  def find_company
    @company = @klass.find(params[:id])
  end

end
