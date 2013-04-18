# encoding: utf-8

class PeopleController < CabinetController
  def index
  end

  def show
    @person = decorate Person.find(params[:id])
    @deals  = decorate @person.deals.published.includes(:investors)
                                    .sort_by(&:date).reverse
  end
end
