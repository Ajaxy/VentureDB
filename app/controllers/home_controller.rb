# encoding: utf-8

class HomeController < ApplicationController
  respond_to :html, :json

  layout 'home'

  def index
  end

  def about
  end

  def promo
    redirect_to :about if current_user
  end

  def subscribe
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

