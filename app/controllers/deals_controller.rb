# encoding: utf-8

class DealsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def index
    @sorter = DealSorter.new(params, view_context)
    @filter = DealFilter.new(params[:filter])
    scope   = paginate Deal.includes{[project.authors, investors.actor]}
    scope   = @sorter.sort(scope)
    @deals  = decorate @filter.filter(scope).uniq
  end

  def directions
    @chart = DirectionsChart.new(params[:id])
  rescue ArgumentError
    raise_404
  end

  def dynamics
    @chart = DynamicsChart.new
  end

  def geography
  end

  def rounds
  end

  def stages
  end

  def instruments
  end
end
