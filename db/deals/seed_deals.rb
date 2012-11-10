# encoding: utf-8
require "csv"
require File.expand_path("../deal_loader", __FILE__)

file = File.expand_path("../deals.csv", __FILE__)

columns = %w[id project_name project_authors project_authors_contacts approx_date -
             announcement_date contract_date status investor_names investor_types
             investor_locations investment_instruments investment_shares -
             company_full_name company_name company_form company_location
             company_place project_scopes project_description project_markets
             stage round amount - - approx_amount - value_before value_after -
             legal_advisor financial_advisor mentions comments informer_info]

CSV.foreach(file) do |row|
  row.map! { |val| val.strip if val }
  data    = Hash[columns.zip(row)].with_indifferent_access
  loader  = Loader.new(data)
  loader.load!
end
