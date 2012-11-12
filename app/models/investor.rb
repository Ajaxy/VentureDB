# encoding: utf-8

class Investor < ActiveRecord::Base
  self.inheritance_column = "_type"

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings

  belongs_to :actor, polymorphic: true
  has_many :investments

  TYPES = {
    1  => "Государственный фонд/организация",
    2  => "Корпорация",
    3  => "Корпоративный венчурный фонд",
    4  => "Частный венчурный фонд",
    5  => "Фонд прямых инвестиций",
    6  => "Фонд фондов",
    7  => "Инвестиционный банк",
    8  => "Инвестиционная компания",
    9  => "Прочие институциональные инвесторы",
    10 => "Бизнес-ангел",
    11 => "Прочие фонды",
    12 => "Прочие физлица (включая FFF)",
    13 => "Прочие организации (юрлица)",
  }

  def actor_name
    actor.name
  end

  def name
    "#{actor_name} – #{type}"
  end

  def type
    TYPES[type_id]
  end
end