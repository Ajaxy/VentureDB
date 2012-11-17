# encoding: utf-8

class Admin::PeopleController < Admin::BaseController
  def show
    @person = Author.find(params[:id])
    @type   = "author"
    render :success
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
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes(permitted_params.person)
      flash.now[:notice] = "Информация о человеке обновлена."
      render :edit
    else
      render :edit
    end
  end
end
