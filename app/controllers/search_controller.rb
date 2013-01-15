# encoding: utf-8

class SearchController < CabinetController
  respond_to :json

  CLASSES_FOR_FULLTEXT_SEARCH = [Deal, Project, Investor].freeze

  def index
    records  = ThinkingSphinx.search(params[:search], classes: CLASSES_FOR_FULLTEXT_SEARCH)
    @records = decorate(records)
  end

  def suggest
    suggester = Suggester.new(params[:query], params[:entities])
    entities  = suggester.suggest

    respond_with(entities)
  end

  private

  def decorate(records)
    records.map do |record|
      if record.is_a? Deal
        StreamDealDecorator.decorate(record)
      else
        super(record)
      end
    end
  end
end
