# encoding: utf-8

class Participation < ActiveRecord::Base
  self.inheritance_column = "_type"

  TYPES = {
    1 => "Представитель фонда",
    2 => "Частный инвестор",
    3 => "Аналитик",
  }

  def type
    TYPES[type_id]
  end

  validates :type_id, :name, :phone, :text, presence: true
end
