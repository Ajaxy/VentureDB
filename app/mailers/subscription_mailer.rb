# encoding: utf-8

class SubscriptionMailer < ActionMailer::Base
  helper :application
  default from: SUBSCRIPTION_CONFIRMATION_FROM_ADDR

  def approved(user)
    @user = user

    mail to:      @user.email,
         subject: "Регистрация на venture.bi"
  end
end
