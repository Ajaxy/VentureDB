# encoding: utf-8

class DealsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter = DealSorter.new(params, view_context, default: :date)
    @filter = decorate DealFilter.new(params), view: view_context, sorter: @sorter
    scope   = Deal.includes{[project.authors, investors.actor]}.published
    scope   = paginate @sorter.sort(scope)
    @deals  = StreamDealDecorator.decorate @filter.filter(scope)
  end

  def overview
    @overview = DealsOverview.new params.slice(:year, :scope)
  end

  def show
    @deal = decorate Deal.find(params[:id])
  end
end
