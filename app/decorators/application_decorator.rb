# encoding: utf-8

class ApplicationDecorator < Draper::Decorator
  delegate :downcase, :upcase, to: :UnicodeUtils
  delegate_all

  def link(options = {})
    text  = options[:text] || model.name
    scope = options.delete(:scope)
    h.link_to text, [scope, model].compact
  end

  def edit_link(options = {})
    text  = options.delete(:text) || "Редактировать"
    options.reverse_merge!(class: "btn btn-primary")

    h.link_to text, edit_path, options
  end

  def edit_path
    [:edit, :admin, model]
  end

  private

  def list(strings)
    strings.join("<br>").html_safe
  end

  def mdash
    tag :span, "—", class: "mdash"
  end

  def dollars(amount, options = {})
    units = { unit: "" }

    case options[:format]
    when :short
      units[:thousand] = "K"
      units[:million]  = "M"
      units[:billion]  = "B"

      format = "%n%u"
      default_precision = amount >= 1_000_000_000 ? 1 : 0
    else
      units[:thousand] = "тыс."
      units[:million]  = "млн"
      units[:billion]  = "млрд"
      default_precision = amount >= 1_000_000 ? 1 : 0
    end

    precision = options.delete(:precision) || default_precision

    options = {
      units: units,
      precision: precision,
      strip_insignificant_zeros: true,
      separator: ",",
      format: format,
    }

    "$" + h.number_to_human(amount, options).gsub(" ", " ")
  end

  def rubles(amount)
    txt = ''

    if amount % 1000000 == 0
      amount /= 1000000
      txt = ' млн'
    elsif amount % 1000 == 0
      amount /= 1000
      txt = ' тыс'
    end

    "#{h.number_with_delimiter amount, delimiter: " "}#{txt} руб."
  end

  def tag(*args, &block)
    h.content_tag(*args, &block)
  end
end
