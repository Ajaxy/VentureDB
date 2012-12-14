# encoding: utf-8

class HomeController < ApplicationController
  def index
  end

  def promo
    redirect_to :deals if current_user
  end

  def subscribe
    @subscription = Subscription.new(permitted_params.subscription)

    if @subscription.save
      redirect_to :subscribed
    else
      render :promo
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

