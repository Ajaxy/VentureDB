# encoding: utf-8

class UserDecorator < ApplicationDecorator
  decorates :user
  decorates_association :person

  def type
    User::TYPES[user.type]
  end

  def link
    super(text: user.email, scope: :admin)
  end

  def created_at
    h.localize user.created_at.to_date
  end

  def user; source; end
end
