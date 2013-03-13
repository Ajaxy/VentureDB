# encoding: utf-8

class Investor < ActiveRecord::Base
  include HasInvestments
  include InvestorActor
  include Searchable

  # self.inheritance_column = "_type"

  has_many :investments, as: :investor_entity
  has_many :deals, through: :investments
  has_many :projects, through: :deals
  has_many :scopes, through: :projects

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings

  validates :type_id, presence: true
  
  # TODO: Update types
  # TYPES = {
  #   1 => "Венчурные фонды с государственным участием",
  #   2 => "Корпорации и корпоративные венчурные фонды",
  #   3 => "Частные венчурные фонды",
  #   4 => "Управляющие компании",
  #   5 => "Фонды с государственным участием",
  #   6 => "Частные организации",
  #   7 => "Банки",
  #   8 => "Кредитная организация"
  # }

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

  COMPANY_TYPES = (1..10).to_a + [12,14]
  PERSON_TYPES = [11, 13]

  define_index "investors_index" do
    indexes "ltrim(investors.name)", as: :name

    where "investors.draft = 'f'"
  end

  define_index "prefix_investors_index" do
    indexes "ltrim(investors.name)", as: :name

    where "investors.draft = 'f'"
    set_property min_prefix_len: 3
  end

  

  

  def person
    @person ||= is_person? ? actor : Person.new
  end

  def company
    @company ||= is_company? ? actor : Company.new
  end

  def company=(params)
    actor.update_attributes(params) if is_company?
  end

  def person=(params)
    actor.update_attributes(params) if is_person?
  end

  def is_company?
    actor.is_a?(Company)
  end

  def is_person?
    actor.is_a?(Person)
  end

  def self.with_actor
    where{(actor_id != nil) & (type_id != nil)}.includes{actor}
  end

  def name_and_type
    "#{name} – #{type}"
  end

  def type
    TYPES[type_id]
  end

  def publish
    super
    actor.try(:publish)
  end
end
