# encoding: utf-8

class Suggester
  ALLOWED_ENTITY_TYPES = %w[investor project company person]

  def initialize(query, entites_string)
    @query          = query
    @entites_string = entites_string
  end

  def suggest
    entites_classes.map do |klass|
      klass.search(@query)
    end.flatten
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
