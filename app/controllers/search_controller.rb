# encoding: utf-8

class SearchController < CabinetController
  respond_to :json

  CLASSES_FOR_SEARCH = [Deal, Investor, Company].freeze

  def index
    if params[:search].present?
      records  = ThinkingSphinx
        .search(params[:search], classes: CLASSES_FOR_SEARCH, star: true)
        .page(params[:page])
      @records = PaginatingDecorator.decorate records
    end
  end

  def suggest
    suggester = Suggester.new(params[:query], params[:entities])
    entities  = suggester.suggest

    respond_with(entities.as_json(title_with_type: suggester.multi_entities?))
  end
end
