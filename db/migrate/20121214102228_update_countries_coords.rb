# encoding: utf-8

class UpdateCountriesCoords < ActiveRecord::Migration
  def up
    Location.where{x != nil}.find_each do |location|
      location.y += 30
      location.save!
    end

    coords = {
      "Соединенное Королевство" => [220, 65],
      "Германия"                => [297, 80],
      "Джерси"                  => [218, 100],
      "Франция"                 => [246, 119],
      "Нидерланды"              => [265, 80],
      "Люксембург"              => [270, 95],
      "Швейцария"               => [285, 122],
    }

    coords.each do |name, coords|
      location   = Location.find_by_name!(name)
      location.x = coords[0]
      location.y = coords[1]
      location.save!
    end
  end

  def down
    raise "Can't rollback this migration"
  end
end
