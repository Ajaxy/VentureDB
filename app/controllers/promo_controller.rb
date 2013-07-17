# encoding: utf-8

class PromoController < ApplicationController
  respond_to :html, :json

  layout 'promo'

  def login
    redirect_to :root if current_user
  end

  def subscribe
    redirect_to :root if current_user
  end

  def plans
    @plans = []

    (1..4).each do |id|
      @plans[id] = PlansDecorator.decorate(Plans.get(id))
    end
  end

  def subscribe_post
    @subscription = Subscription.new(permitted_params.subscription)

    if @subscription.user_registered?
      @subscription.user.remind_already_registered
      respond_with(@subscription, location: nil) do |format|
        format.html { redirect_to root_path }
      end
    else
      if @subscription.save
        respond_with(@subscription, location: nil) do |format|
          format.html { redirect_to root_path }
        end
      else
        respond_with @subscription
      end
    end
  end
end

