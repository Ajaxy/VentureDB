# encoding: utf-8

class SubscriptionMailer < ActionMailer::Base
  helper :application
  default from: FROM_EMAIL_ADDRESS

  def approved(user)
    @user = user

    mail to:      @user.email,
         subject: "Регистрация на venture.bi"
  end
end
