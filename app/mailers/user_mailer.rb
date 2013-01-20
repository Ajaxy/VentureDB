# encoding: utf-8

class UserMailer < ActionMailer::Base
  helper :application
  default from: FROM_EMAIL_ADDRESS

  def created(user)
    @user = user

    mail to:      user.email,
         subject: "Регистрация на venture.bi"
  end

  def remind_already_registered(user)
    @user = user

    mail to: user.email,
         subject: "Регистрация на venture.bi"
  end
end
