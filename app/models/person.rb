# encoding: utf-8

class Person < ActiveRecord::Base
  include Draftable
  include InvestorActor

  has_one :user

  has_many :project_authors, foreign_key: "author_id"
  # has_many :projects

  def self.by_name
    # order(:first_name, :last_name)
    all.sort_by(&:full_name)
  end

  def self.find_or_create_draft(params)
    if person = where(params.slice(:first_name, :last_name, :email)).first
      person
    else
      create_draft(params)
    end
  end

  def self.sql_search(query)
    return scoped unless query.present?
    search = "%#{query}%".gsub('.','_')

    where do
      first_name.like(search) |
      middle_name.like(search) |
      last_name.like(search)
    end
  end

  def full_name
    if middle_name?
      "#{last_name} #{first_name} #{middle_name}"
    else
      "#{first_name} #{last_name}"
    end
  end
  alias_method :name, :full_name

  def full_name_with_email
    "#{full_name} #{email}"
  end
end
