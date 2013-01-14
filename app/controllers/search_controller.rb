# encoding: utf-8

class SearchController < CabinetController
  respond_to :json

  def index
  end

  def suggest
    suggester = Suggester.new(params[:query], params[:entities])
    entities   = suggester.suggest

    respond_with(entities)
  end
end
