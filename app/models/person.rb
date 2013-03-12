# encoding: utf-8

class Person < ActiveRecord::Base
  include Searchable
  
  TYPES = {
    11 => "Бизнес-ангел",
    13 => "Прочие физлица (включая FFF)"
  }

  # include Draftable
  has_many :connection_binding
  has_many :connections, through: :connection_binding, as: :connection

  has_one  :user
  has_many :project_authors, foreign_key: "author_id"
  
  has_and_belongs_to_many :sectors, class_name: 'Scope'

  has_many :location_bindings, as: :entity
  has_many :locations, through: :location_bindings

  has_many :investments, as: :investor_entity
  
  store :contacts, accessors:[ :address, :telephone, :website,
                      :facebook, :slideshare, :vkontakte, :vacancies,
                      :jobs, :media, :other]

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

  # def full_name
    # if middle_name?
    #   "#{last_name} #{first_name} #{middle_name}"
    # else
    #   "#{first_name} #{last_name}"
    # end
  # end

  def name
    full_name
  end

  def full_name_with_email
    "#{full_name} #{email}"
  end
end
