# encoding: utf-8
require "csv"

usa = Location.where(name: "Соединенные Штаты").first
usa_cities = Rails.root.join("db/locations/usa.txt")

CSV.foreach(usa_cities, col_sep: "\t") do |row|
  cols = %w[- city - state]

  data = Hash[cols.zip(row)].except("-")

  unless state = Location.where(name: data["state"]).first
    state = Location.where(name: data["state"]).create!
    state.move_to_child_of(usa)
  end

  if data["city"].present?
    city = Location.create!(name: data["city"])
    city.move_to_child_of(state)
    # puts "#{data["city"]} -> #{data["state"]}"
  end
end
