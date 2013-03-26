# encoding: utf-8

class PeopleController < CabinetController
  def index
  end

  def show
    @person = decorate Person.find(params[:id])
    @deals  = decorate @person.deals.order_by_started_at(:desc)
  end
end
