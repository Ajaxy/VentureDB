# encoding: utf-8

class InvestmentsController < ApplicationController
  before_filter :require_admin!

  def create
    @investment = Investment.new_draft(permitted_params.investment)

    if @investment.save
      render :success
    else
      render :error
    end
  end
end
