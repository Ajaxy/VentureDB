class CompanyDecorator < ApplicationDecorator
  decorates :company

  def type
    Company::TYPES[source.type_id]
  end

  def scope_names
    return mdash unless scopes.any?
    list scopes.map(&:name)
  end
end
