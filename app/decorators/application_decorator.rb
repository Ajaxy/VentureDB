# encoding: utf-8

class ApplicationDecorator < Draper::Base
  # include Draper::LazyHelpers
  delegate :link_to, :content_tag, to: :h
  delegate :l, :localize, to: :I18n

  def link
    link_to model.name, model
  end

  private

  def list(strings)
    strings.join("<br>").html_safe
  end

  def roubles(amount)
    "#{h.number_with_delimiter amount, delimiter: " "} руб."
  end
end
