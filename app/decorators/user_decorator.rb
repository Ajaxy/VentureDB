# encoding: utf-8

class UserDecorator < ApplicationDecorator
  decorates :user

  def type
    User::TYPES[user.type]
  end

  def link
    super(text: user.email, scope: :admin)
  end
end
