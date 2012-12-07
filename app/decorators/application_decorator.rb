# encoding: utf-8

class ApplicationDecorator < Draper::Base
  def link(options = {})
    text  = options[:text] || model.name
    scope = options.delete(:scope)
    h.link_to text, [scope, model].compact
  end

  private

  def list(strings)
    strings.join("<br>").html_safe
  end

  def millions(amount, options = {})
    options = options.merge(units: { unit: "руб.", thousand: "тыс. руб.", million: "млн руб."})
    options[:precision] ||= 0
    h.number_to_human amount, options
  end

  def roubles(amount)
    "#{h.number_with_delimiter amount, delimiter: " "} руб."
  end

  def tag(*args, &block)
    h.content_tag(*args, &block)
  end
end
