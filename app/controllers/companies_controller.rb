# encoding: utf-8

class CompaniesController < CabinetController
  def index
  end

  def show
    @company = decorate Company.find(params[:id])
  end
end