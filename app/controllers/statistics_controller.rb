# encoding: utf-8

class StatisticsController < CabinetController
  def index
    @overview = DealsOverview.new params.slice(:year, :scope)

    if request.xhr?
      render partial: "graphs"
    else
      render :index
    end
  end
end
