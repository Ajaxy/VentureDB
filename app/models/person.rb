# encoding: utf-8

class Person < ActiveRecord::Base
  include Draftable
  include InvestorActor
  include Connectable

  TYPES = {
    1 => "Эксперт",
    2 => "Бизнес-ангел"
  }
  CONTACTS_FIELDS = [:address, :phone, :website, :facebook, :slideshare, :vkontakte, :vacancies,
    :metions, :other_geo]

  has_one :user
  has_many :project_authors, foreign_key: 'author_id'

  validates :name, presence: true
  validates :sex, inclusion: { in: %w[m f] }, allow_blank: true
  validates :type_id, presence: true, inclusion: { in: TYPES.keys }

  def self.by_name
    order('name ASC')
  end

  def self.find_or_create_draft(params)
    if person = where(params.slice(:first_name, :last_name, :email)).first
      person
    else
      create_draft(params)
    end
  end

  def self.suggest(query)
    return scoped unless query.present?
    search = "%#{query}%".gsub('.','_')

    where do
      first_name.like(search) |
      middle_name.like(search) |
      last_name.like(search)
    end
  end

  def full_name; name; end

  def full_name_with_email
    "#{full_name} #{email}"
  end

  def contacts
    CONTACTS_FIELDS.inject({}) do |result, field|
      result[field] = self[field] if self[field].present?
      result
    end
  end
end
