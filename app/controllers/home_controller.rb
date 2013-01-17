# encoding: utf-8

class HomeController < ApplicationController
  respond_to :html, :json

  def index
  end

  def promo
    redirect_to :deals if current_user
  end

  def subscribe
    @subscription = Subscription.new(permitted_params.subscription)

    if @subscription.user_registered?
      @subscription.user.remind_already_registered
      respond_with @subscription, location: nil
    else
      if @subscription.save
        respond_with @subscription, location: nil
      else
        respond_with @subscription
      end
    end
  end

  def subscribed
    @participation = Participation.new
  end

  def participate
    @participation = Participation.new(permitted_params.participation)

    if @participation.save
      redirect_to :root
    else
      render :subscribed
    end
  end
end

