# encoding: utf-8
require "csv"
require File.expand_path("../companies_loader", __FILE__)

file = File.expand_path("../companies.csv", __FILE__)


CSV.foreach(file) do |row|
  row.map! { |val| val.strip if val }
  loader  = Loader.new(row)
  loader.load!
end
