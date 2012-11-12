# encoding: utf-8

class InvestorsController < ApplicationController
  def index
    scope = Investor.with_actor.sort_by(&:name)
    @investors = Kaminari.paginate_array(scope).page(params[:page]).per(50)
  end

  def create
    @investor = InvestorForm.new(permitted_params.investor)

    if @investor.save
      render :success
    else
      render :error
    end
  end
end
