# encoding: utf-8

class CompanyFilter < Filter
  def filter(companies)
    companies = companies.search(search)  if search
    companies = companies.in_scopes(params.sector)      if params.sector.present?
    companies = companies.in_types(params.company_type) if params.company_type.present?

    companies
  end
end
