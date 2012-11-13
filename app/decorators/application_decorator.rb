# encoding: utf-8

class ApplicationDecorator < Draper::Base
  def link(options = {})
    text = options[:text] || model.name
    h.link_to text, model
  end

  private

  def list(strings)
    strings.join("<br>").html_safe
  end

  def roubles(amount)
    "#{h.number_with_delimiter amount, delimiter: " "} руб."
  end

  def tag(*args, &block)
    h.content_tag(*args, &block)
  end
end
