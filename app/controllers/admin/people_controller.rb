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

    klass   = @type == "author" ? Author : Informer
    @person = klass.find_or_create_draft(permitted_params.person)

    if @person.valid?
      render :success
    else
      render :error
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

  private

  def find_person
    @person = Person.find(params[:id])
  end
end
