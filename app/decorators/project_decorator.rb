# encoding: utf-8

class ProjectDecorator < HasInvestmentsDecorator
  decorates :project

  def company_name
    company.try(:name) || mdash
  end

  def company_contacts
    company.contacts if company
  end

  def scope_names
    return mdash unless scopes.any?
    list scopes.map(&:name)
  end

  def author_names
    return mdash unless authors.any?
    list authors.map(&:full_name)
  end

  def market_names
    return mdash unless markets.any?
    list markets.map(&:name)
  end

  def meta
    scope_names = project.scopes.map(&:full_name)
    year        = company.creation_date.try(:year) if company
    [*scope_names, year].compact.join(", ")
  end

  def first_location
    location_bindings.try(:first).try(:location).try(:full_name) || mdash
  end

  def deals_sum
    tag :span, dollars(source.deals_sum), class: "amount"
  end

  private

  def project; source; end
end
