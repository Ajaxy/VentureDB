# encoding: utf-8

class Location < ActiveRecord::Base
  acts_as_nested_set
end
