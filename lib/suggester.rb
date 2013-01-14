# encoding: utf-8

class Suggester
  ALLOWED_ENTITY_TYPES = %w[investor project company person]

  def initialize(query, entites_string)
    @query          = query
    @entites_string = entites_string
  end

  def suggest
    found = entites_classes.map do |klass|
      klass.sql_search(@query).limit(SEARCH_AUTOSUGGEST_LIMIT)
    end.flatten

    SuggestEntityDecorator.decorate(found).sort_by(&:name).first(SEARCH_AUTOSUGGEST_LIMIT)
  end

  private

  def entites
    if @entites_string == 'all'
      ALLOWED_ENTITY_TYPES
    else
      @entites_string.split(',') & ALLOWED_ENTITY_TYPES
    end
  end

  def entites_classes
    entites.map { |entity| entity.classify.constantize }
  end
end
