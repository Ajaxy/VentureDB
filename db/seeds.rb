# encoding: utf-8
require "csv"

require_relative "locations/seed_locations"
require_relative "scopes/seed_scopes"
require_relative "deals/seed_deals"
require_relative "companies/seed_companies"

User.create!(email: "ai@grow.bi", password: "grow123").confirm!
