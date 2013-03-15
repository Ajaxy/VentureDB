# encoding: utf-8

class Person < ActiveRecord::Base
  include Draftable
  include InvestorActor
  include Connectable

  TYPES = {
    1 => "Эксперт",
    2 => "Бизнес-ангел"
  }

  has_one :user
  has_many :project_authors, foreign_key: 'author_id'

  validates :sex, inclusion: { in: %w[m f] }, allow_blank: true

  def self.by_name
    all.sort_by(&:full_name)
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
end
