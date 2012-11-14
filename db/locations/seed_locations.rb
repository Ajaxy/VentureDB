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

cyprus = Location.where(name: "Кипр").first
%w[Ларнака Никосия Лимасол].each do |name|
  city = Location.create!(name: name)
  city.move_to_child_of(cyprus)
end

virgin = Location.where(name: "Виргинские Острова, Британские").first
tortola = Location.create!(name: "Тортола")
tortola.move_to_child_of(virgin)

require_relative "seed_russia"
require_relative "seed_usa"
require_relative "seed_uk"
