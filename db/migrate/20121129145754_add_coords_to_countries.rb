# encoding: utf-8

class AddCoordsToCountries < ActiveRecord::Migration
  def up
    add_column :locations, :x, :integer
    add_column :locations, :y, :integer

    coords = {
      "Россия" => [570, 83],
      "Соединенные Штаты" => [152, 171],
      "Соединенное Королевство" => [383, 123],
      "Кипр" => [469, 180],
      "Китай" => [626, 175],
      "Германия" => [419, 136],
      "Джерси" => [384, 141],
      "Виргинские Острова, Британские" => [241, 222],
      "Острова Кайман" => [202, 220],
      "Швеция" => [429, 95],
      "Франция" => [400, 146],
      "Нидерланды" => [404, 132],
      "Люксембург" => [405, 141],
      "Япония" => [716, 176],
      "Латвия" => [449, 118],
      "Швейцария" => [409, 149],
    }

    coords.each do |name, coords|
      location   = Location.find_by_name!(name)
      location.x = coords[0]
      location.y = coords[1]
      location.save!
    end
  end

  def down
    remove_column :locations, :x
    remove_column :locations, :y
  end
end
