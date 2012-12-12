# encoding: utf-8

class InvestorDecorator < ApplicationDecorator
  decorates :investor

  def amount
    millions investor.investments_amount
  end

  def creation_date
    return unless date = investor.company.try(:creation_date)
    date = localize date, format: "%B %Y"
    "Дата основания: #{downcase date}"
  end

  def company_contacts
    company.contacts if company
  end

  def count
    investor.deals.size
  end

  def description
    [investor.type, *investor.locations.map(&:name)].join(", ")
  end

  def location_names
    return "—" unless locations.any?
    list locations.map(&:name)
  end

  def meta
    result  = tag :div, description, class: "pull-left"
    result += tag :div, creation_date, class: "pull-right" if creation_date
    result
  end
end
