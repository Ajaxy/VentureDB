# encoding: utf-8

class InvestorsController < ApplicationController
  def index
    scope = Investor.where{actor_id != nil}.where{type_id != nil}.includes(:actor).sort_by(&:name)
    @investors = Kaminari.paginate_array(scope).page(params[:page]).per(50)
  end
end
