# encoding: utf-8

class Investor < ActiveRecord::Base
  include Draftable

  self.inheritance_column = "_type"

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings

  belongs_to :actor, polymorphic: true

  has_many :investments
  has_many :deals, through: :investments

  validates :type_id, presence: true

  TYPES = {
    1  => "Государственный фонд",
    2  => "Государственная организация",
    3  => "Корпорация",
    4  => "Корпоративный венчурный фонд",
    5  => "Частный венчурный фонд",
    6  => "Фонд прямых инвестиций",
    7  => "Фонд фондов",
    8  => "Инвестиционный банк",
    9  => "Инвестиционная компания",
    10  => "Прочие институциональные инвесторы (пенсионные фонды, страховые" +
          " компании и др.)",
    11 => "Бизнес-ангел",
    12 => "Прочие фонды",
    13 => "Прочие физлица (включая FFF)",
    14 => "Прочие организации (юрлица)",
  }

  PERSON_TYPES = [11, 13]

  def self.in_location(location)
    joins{locations}.where{(locations.lft >= location.lft) &
                           (locations.lft < location.rgt)}
  end

  def person
    actor.is_a?(Person) ? actor : Person.new
  end

  def company
    actor.is_a?(Company) ? actor : Company.new
  end

  def self.with_actor
    where{(actor_id != nil) & (type_id != nil)}.includes{actor}
  end

  def actor_name
    actor.try(:name)
  end

  def name
    actor_name
  end

  def name_and_type
    "#{actor_name} – #{type}"
  end

  def type
    TYPES[type_id]
  end

  def publish
    super
    actor.try(:publish)
  end

  def investments_amount
    investments.map { |inv| inv.deal.try(:amount) || 0 }.sum
  end
end
