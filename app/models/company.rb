# encoding: utf-8

class Company < ActiveRecord::Base
  include Trackable
  include Draftable
  include InvestorActor
  include Connectable

  TYPES = {
    1 => "Ассоциация",
    2 => "Институт развития",
    3 => "Медиа и СМИ",
    4 => "Организатор мероприятий"
  }

  has_many :users
  has_one :project

  # validates :name, :full_name, :form, :place, presence: true
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
