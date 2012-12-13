# encoding: utf-8

class UserMailer < ActionMailer::Base
  helper :application
  default from: "admin@venture.bi"

  def created(user)
    @user = user

    mail to:      user.email,
         subject: "Регистрация на venture.bi"
  end
end
