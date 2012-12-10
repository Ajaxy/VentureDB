# encoding: utf-8

class InvestorsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter     = InvestorSorter.new(params)
    @filter     = decorate InvestorFilter.new(params), view: view_context,
                                                       sorter: @sorter

    scope       = Investor.published.with_actor.includes{investments.deal}
    scope       = @sorter.sort(scope)
    scope       = @filter.filter(scope)

    @investors  = decorate paginate(scope)
  end

  def show
    @investor = decorate Investor.find(params[:id])
  end
end
