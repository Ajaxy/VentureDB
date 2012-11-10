# encoding: utf-8
require "csv"

file    = Rails.root.join("db/countries.txt")
columns = %w[name full_name - - -]

CSV.open Rails.root.join("db/countries.csv"), "w" do |csv|
  CSV.foreach(file, col_sep: "\t") do |row|
    attrs = Hash[columns.zip(row)]

    attrs["name"] = UnicodeUtils.titlecase(attrs["name"])
    attrs["name"].gsub!(/\bИ\b/, "и")
    attrs["name"].gsub!(/\bВ\b/, "в")
    attrs["name"].gsub!("Сша", "США")

    csv << attrs.except("-").values
  end
end
