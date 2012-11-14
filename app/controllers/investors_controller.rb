# encoding: utf-8

class InvestorsController < ApplicationController
  def index
    @sorter    = InvestorSorter.new(params, view_context)
    scope      = @sorter.sort(Investor.published.with_actor)
    @investors = paginate(scope)
  end

  def create
    @investor = InvestorForm.new(params[:investor])

    if @investor.save
      render :success
    else
      render :error
    end
  end
end
