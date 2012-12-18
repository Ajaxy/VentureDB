# encoding: utf-8

class SeriesDecorator < ApplicationDecorator
  def amount_string
    dollars(amount, format: :short)
  end

  def average_amount_string
    dollars(average_amount, format: :short)
  end

  def count_string
    "#{count} #{I18n.t :deals, count: count}"
  end

  def as_json(*values)
    hash = model.as_json

    values.each do |name|
      next unless name.is_a? Symbol
      name = "#{name}_string"
      hash[name] = send(name)
    end

    hash
  end

  def for_stage(*args)
    SeriesDecorator.decorate model.for_stage(*args)
  end

  def tooltip
    tag(:div, class: "tooltip fade in right") do
      tag(:div, "", class: "tooltip-arrow") +
      tag(:div, class: "tooltip-inner") do
        "#{name}<br>#{count_string}<br>#{amount_string}".html_safe
      end
    end
  end
end
