# encoding: utf-8

class SubscriptionMailer < ActionMailer::Base
  helper :application
  default from: "admin@venture.bi"

  def approved(user)
    @user = user

    mail to:      @user.email,
         subject: "Регистрация на venture.bi"
  end
end
