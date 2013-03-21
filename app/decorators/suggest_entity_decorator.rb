# encoding: utf-8

class SuggestEntityDecorator < ApplicationDecorator
  MAPPING = {
    "company"  => "компания",
    "person"   => "человек",
    "project"  => "проект",
    "investor" => "инвестор"
  }

  def title
    source.try(:name) or source.try(:full_name)
  end

  def title_with_type
    "#{title} (#{display_type})"
  end

  def as_json(options = {})
    {
      id:    id,
      type:  type,
      title: options[:title_with_type] ? title_with_type : title,
      url:   helpers.url_for(source)
    }
  end

  private

  def type
    source.class.name.downcase
  end

  def display_type
    MAPPING[type]
  end
end
