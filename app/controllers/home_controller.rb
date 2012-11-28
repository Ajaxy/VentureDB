# encoding: utf-8

class HomeController < ApplicationController
  def index
  end

  def promo
  end

  def subscribe
    @subscription = Subscription.new(email: params[:email])

    if @subscription.save
      render :subscribed
    else
      render :promo
    end
  end
end

