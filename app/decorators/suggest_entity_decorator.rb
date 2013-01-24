# encoding: utf-8

class SuggestEntityDecorator < ApplicationDecorator
  def title
    source.try(:name) or source.try(:full_name)
  end

  def as_json(options = {})
    {
      id:    id,
      type:  source.class.name.downcase,
      title: title,
      url:   helpers.url_for(source)
    }
  end
end
