# encoding: utf-8

class DealsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter = DealSorter.new(params, view_context, default: :date)
    @filter = decorate DealFilter.new(params), view: view_context,
                                               sorter: @sorter

    scope   = Deal.published.includes{[project.authors, project.scopes.parent,
                                       investors.actor, investors.locations]}

    scope   = paginate @sorter.sort(scope)
    scope   = @filter.filter(scope).uniq

    @deals  = StreamDealDecorator.decorate(scope)
  end

  def overview
    @overview = DealsOverview.new params.slice(:year, :scope)

    if request.xhr?
      render partial: "graphs"
    else
      render :overview
    end
  end

  def show
    @deal = decorate Deal.find(params[:id])
  end
end
