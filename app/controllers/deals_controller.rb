# encoding: utf-8

class DealsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def overview
    @overview = DealsOverview.new params.slice(:year, :scope)
  rescue DealsOverview::NoDataError
    raise "lol"
  end

  def index
    @sorter = DealSorter.new(params, view_context)
    @filter = DealFilter.new(params[:filter])
    scope   = paginate Deal.includes{[project.authors, investors.actor]}
    scope   = @sorter.sort(scope)
    @deals  = decorate @filter.filter(scope).uniq
  end

  def show
    @deal = decorate Deal.find(params[:id])
  end
end
