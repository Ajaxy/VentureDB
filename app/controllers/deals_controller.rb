# encoding: utf-8

class DealsController < ApplicationController
  layout "cabinet"
  before_filter :authenticate_user!

  def directions
    @chart = DirectionsChart.new(params[:id])
  rescue ArgumentError
    raise_404
  end

  def growth
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
