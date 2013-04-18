# encoding: utf-8

class Feedback < ActiveRecord::Base
  self.inheritance_column = "_type"

  TYPES = {
    1 => "Проведение исследования",
    2 => "Структурированные данные",
    3 => "Консультация по венчурному рынку",
  }

  def type
    TYPES[type_id] || TYPES[0]
  end
end
