# encoding: utf-8

class Admin::InvestmentsController < Admin::BaseController
  def create
    @investment = Investment.new_draft(permitted_params.investment)

    if @investment.save
      render :success
    else
      render :error
    end
  end
end
