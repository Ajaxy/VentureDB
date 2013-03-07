# encoding: utf-8

class Company < ActiveRecord::Base
  include Trackable
  include Draftable
  include InvestorActor

  TYPES = {
    1 => "Ассоциация",
    2 => "Институт развития",
    3 => "Медиа и СМИ",
    4 => "Организатор мероприятий"
  }

  has_many :users
  has_many :locations
  has_one  :project
  has_many :sectors, through: :project, source: :scopes

  store :contacts, accessors:[ :address, :telephone, :website,
                      :facebook, :slideshare, :vkontakte, :vacancies,
                      :jobs, :media, :other]

  validates :name, presence: true
  validates :type_id, inclusion: { in: TYPES.keys }, allow_nil: true

  def self.find_or_create(params, user)
    if company = where(params.slice(:name)).first
      company
    else
      create_tracking_user(user, params)
    end
  end

  def self.suggest(query)
    return scoped unless query.present?
    search = "%#{query}%".gsub('.','_')

    where{ name.like(search) }
  end

  def self.order_by_name(direction)
    order("#{table_name}.name #{direction}")
  end
end
