# encoding: utf-8

class LocationBinding < ActiveRecord::Base
  belongs_to :entity, polymorphic: true
  belongs_to :location
end
