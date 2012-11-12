# encoding: utf-8

class InvestmentsController < ApplicationController
  before_filter :require_admin!

  def create
    @investment = Investment.find_or_create(params[:investment])

    if @investment.valid?
      render :show
    else
      render :error
    end
  end
end
