class CompanyDecorator < HasInvestmentsDecorator
  decorates :company

  def full_name
    source.full_name.blank? ? mdash : source.full_name
  end

  def prev_name
    source.prev_name.blank? ? mdash : source.prev_name
  end

  def form
    source.form.blank? ? mdash : source.form
  end

  def place
    source.place.blank? ? mdash : source.place
  end

  def type
    Company::TYPES[source.type_id]
  end

  def scope_names
    return mdash unless scopes.any?
    list scopes.map(&:name)
  end

  def first_location
    location_bindings.try(:first).try(:location).try(:full_name) || mdash
  end
end
