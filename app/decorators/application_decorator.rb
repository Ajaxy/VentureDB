# encoding: utf-8

class ApplicationDecorator < Draper::Decorator
  delegate :downcase, :upcase, to: :UnicodeUtils
  delegate_all

  def link(options = {})
    text  = options[:text] || model.name
    scope = options.delete(:scope)
    h.link_to text, [scope, model].compact
  end

  def deal_string(count = self.count)
  strcount = count.to_s
    return strcount + ' сделок' if (strcount.length > 1) and (strcount[-2] == '1')
    case strcount[strcount.length-1]
    when '1'
      return strcount + ' сделка'
    when '2','3','4'
      return strcount + ' сделки'
    else
      return strcount + ' сделок'
    end
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

  def roubles(amount)
    "#{h.number_with_delimiter amount, delimiter: " "} руб."
  end

  def tag(*args, &block)
    h.content_tag(*args, &block)
  end
end
