# encoding: utf-8

class Scope < ActiveRecord::Base
  acts_as_nested_set

  def short_name
    self[:short_name] || name
  end

  def full_name(separator = "/")
    [parent.try(:short_name), short_name].compact.join(" #{separator} ")
  end
end

