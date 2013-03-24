# encoding: utf-8

class InvestorDecorator < HasInvestmentsDecorator
  decorates :investor

  def creation_date
    return unless date = investor.company.try(:creation_date)
    date = localize date, format: "%B %Y"
    "Дата основания: #{downcase date}"
  end

  def company_contacts
    company.contacts if company
  end

  def description
    [investor.type, *investor.locations.map(&:name)].join(", ")
  end

  def location_names
    return mdash unless locations.any?
    list locations.map(&:name)
  end

  def meta
    result  = tag :div, description, class: "pull-left"
    result += tag :div, creation_date, class: "pull-right" if creation_date
    result
  end

  def link(options = {})
    text  = options[:text] || model.name
    scope = options.delete(:scope)
    h.link_to text, h.url_for(source.actor)
  end

  def last_deal_date
    date = source.last_deal_date
    date.present? ? h.l(source.last_deal_date) : mdash
  end

  private

  def investor; source; end
end
