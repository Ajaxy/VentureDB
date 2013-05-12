# encoding: utf-8

class Admin::PeopleController < Admin::BaseController
  before_filter :find_person, only: [:show, :edit, :update, :destroy]

  def index
    scope     = paginate Person.scoped
    @people   = PaginatingDecorator.decorate scope
  end

  def show
    render :edit
  end

  def new
    @person = Person.new
  end

  def create
    @type   = params[:type]

    @person = Person.find_or_create(permitted_params.person)

    if @person.valid?
      respond_to do |format|
        format.js   { render :success }
        format.html { redirect_to [:admin, :people] }
      end
    else
      respond_to do |format|
        format.js   { render :error }
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    if @person.update_attributes(permitted_params.person)
      flash.now[:notice] = "Информация о человеке обновлена."
      render :edit
    else
      render :edit
    end
  end

  def destroy
    @person.destroy
    redirect_to [:admin, :people], notice: 'Человек удалён.'
  end

  private

  def find_person
    @person = Person.find(params[:id])
  end
end
