# encoding: utf-8

class AddCoordsToCountries < ActiveRecord::Migration
  def up
    add_column :locations, :x, :integer
    add_column :locations, :y, :integer
  end

  def down
    remove_column :locations, :x
    remove_column :locations, :y
  end
end
