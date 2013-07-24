# encoding: utf-8

class UserDecorator < ApplicationDecorator
  decorates :user
  decorates_association :person

  def name
    object.person.name
  end

  def type
    User::TYPES[object.type]
  end

  def link
    super(text: object.email, scope: :admin)
  end

  def created_at
    h.localize object.created_at.to_date
  end
end
