# encoding: utf-8

class Suggester
  ALLOWED_ENTITY_TYPES = %w[investor project company person]

  def initialize(query, entities_string)
    @query           = query
    @entities_string = entities_string
  end

  def suggest
    found = entities_classes.map do |klass|
      klass.suggest(@query).limit(SEARCH_AUTOSUGGEST_LIMIT)
    end.flatten

    SuggestEntityDecorator.decorate_collection(found).sort_by(&:name).
      first(SEARCH_AUTOSUGGEST_LIMIT)
  end

  private

  def entities
    if @entities_string == 'all'
      ALLOWED_ENTITY_TYPES
    else
      @entities_string.split(',') & ALLOWED_ENTITY_TYPES
    end
  end

  def entities_classes
    entities.map { |entity| entity.classify.constantize }
  end
end
