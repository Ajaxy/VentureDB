# encoding: utf-8

class Person < ActiveRecord::Base
  include Draftable
  include InvestorActor
  include Connectable
  include Searchable

  TYPE_EXPERT_ID          = 1
  TYPE_BUSINESS_ANGEL_ID  = 2

  TYPES = {
    TYPE_EXPERT_ID          => "Эксперт",
    TYPE_BUSINESS_ANGEL_ID  => "Бизнес-ангел"
  }

  CONTACTS_FIELDS = [:address, :phone, :website, :facebook, :slideshare,
                     :vkontakte, :vacancies, :metions, :other_geo]

  has_one :user
  has_many :project_authors, foreign_key: 'author_id'

  validates :name, presence: true
  validates :sex, inclusion: { in: %w[m f] }, allow_blank: true
  validates :type_id, presence: true, inclusion: { in: TYPES.keys }

  before_validation :fill_defaults

  scope :business_angels, -> { where(type_id: TYPE_BUSINESS_ANGEL_ID) }

  define_index "people_index" do
    indexes [first_name, middle_name, last_name], as: :full_name
    indexes description

    where "people.draft = 'f'"
  end

  def self.by_name
    order('name ASC')
  end

  def self.find_or_create(params)
    if person = where(params.slice(:name, :email)).first
      person
    else
      create(params)
    end
  end

  def self.suggest(query)
    return scoped unless query.present?
    search = "%#{query}%".gsub('.','_')

    where { name.like(search) }
  end

  def fill_defaults
    if self.new_record?
      self.type_id = Person::TYPE_EXPERT_ID
      self.plan_started_at ||= Time.now
    end
  end

  def full_name
    name
  end

  def full_name_with_email
    "#{full_name} #{email}"
  end

  def contacts
    CONTACTS_FIELDS.inject({}) do |result, field|
      result[field] = self[field] if self[field].present?
      result
    end
  end

  def investor?
    type_id == TYPE_BUSINESS_ANGEL_ID && investors.any?
  end

  def plan_seconds_rest
   (plan_started_at ? plan_started_at + Plans.get(plan).duration : Date.yesterday.to_time) - Time.now
  end

  def plan_active
    plan_seconds_rest > 0
  end
end
