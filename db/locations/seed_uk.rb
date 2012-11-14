# encoding: utf-8
require "csv"

uk = Location.where(name: "Соединенное Королевство").first
uk_cities = Rails.root.join("db/locations/uk.txt")

CSV.foreach(uk_cities, col_sep: "\t") do |row|
  city = Location.create!(name: row.first)
  city.move_to_child_of(uk)

  puts "#{uk.name} -> #{city.name}"
end
