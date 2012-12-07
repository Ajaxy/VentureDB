# encoding: utf-8

class InvestorsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter    = InvestorSorter.new(params, view_context)
    scope      = @sorter.sort(Investor.published.with_actor)
    @investors = decorate paginate(scope)
  end

  def show
    @investor = decorate Investor.find(params[:id])
  end
end
