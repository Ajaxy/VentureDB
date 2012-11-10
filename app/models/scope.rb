# encoding: utf-8

class Scope < ActiveRecord::Base
  acts_as_nested_set

  def short_name
    self[:short_name] || name
  end
end
