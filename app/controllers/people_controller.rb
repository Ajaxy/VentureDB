# encoding: utf-8

class PeopleController < CabinetController
  def index
  end

  def show
    @person = decorate Person.find(params[:id])
  end
end