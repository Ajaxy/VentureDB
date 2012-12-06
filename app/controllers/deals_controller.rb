# encoding: utf-8

class DealsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter = DealSorter.new(params, view_context)
    @filter = DealFilter.new(params[:filter])
    scope   = Deal.includes{[project.authors, investors.actor]}.published
    scope   = paginate @sorter.sort(scope)
    @deals  = StreamDealDecorator.decorate @filter.filter(scope).uniq
  end

  def overview
    @overview = DealsOverview.new params.slice(:year, :scope)
  end

  def show
    @deal = decorate Deal.find(params[:id])
  end
end
