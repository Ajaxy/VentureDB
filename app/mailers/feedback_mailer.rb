# encoding: utf-8

class FeedbackMailer < ActionMailer::Base
  helper :application
  default from: FROM_EMAIL_ADDRESS

  def notify(feedback)
    @feedback = feedback

    mail to:      "kotov.xq@gmail.com",
         subject: "Фидбэк на venture.bi"
  end
end
