# encoding: utf-8

class Admin::PeopleController < Admin::BaseController
  before_filter :get_klass

  def show
    @person = @klass.find(params[:id])
    render :edit
  end

  def new
    @person = @klass.new
  end

  def create
    method = @klass.to_s.underscore.to_sym
    @person = @klass.new permitted_params.send(method)

    if @person.save
      redirect_to [:admin, @person], notice: "Персона успешно добавлена."
    else
      render :new, error: 'Возникли проблемы.'
    end
  end

  def edit
    @person = @klass.find(params[:id])
  end

  def update
    method = @klass.to_s.underscore.to_sym
    @person = @klass.find(params[:id])

    if @person.update_attributes(permitted_params.send(method))
      render :edit, notice: "Информация о человеке обновлена."
    else
      render :edit
    end
  end

  private

  def get_klass
    type = request.path.split("/")[2]
    klass = type.classify.constantize
    @klass = %[experts angels investors].include?(type) ? klass : Person
  end

end
