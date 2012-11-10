# encoding: utf-8
require "csv"

countries = Rails.root.join("db/locations/countries.csv")

CSV.foreach(countries) do |row|
  cols = %w[name full_name]
  attrs = Hash[cols.zip(row)]
  Location.create!(attrs)
end

specials = "Глобальный рынок, Европа, Азия, Страны СНГ"
specials.split(", ").each{ |name| Location.create!(name: name) }

russia = Location.where(name: "Россия").first

russian_cities = Rails.root.join("db/locations/russia.txt")

areas = Set.new
CSV.foreach(russian_cities, col_sep: "\t") do |row|
  cols = %w[city region area - -]

  data = Hash[cols.zip(row)]
  data["area"] += " район"

  unless area = Location.where(name: data["area"]).first
    area = Location.where(name: data["area"]).create!
    area.move_to_child_of(russia)
  end

  unless region = Location.where(name: data["region"]).first
    region = Location.where(name: data["region"]).create!
    region.move_to_child_of(area)
  end

  city = Location.create!(name: data["city"])
  city.move_to_child_of(region)

  # puts "#{data["city"]} -> #{data["region"]} -> #{data["area"]}"
end
