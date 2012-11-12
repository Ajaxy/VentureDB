# encoding: utf-8

class CompaniesController < ApplicationController
  before_filter :require_admin!

  def create
    @company = Company.find_or_create(params[:company], current_user)

    if @company.valid?
      render :success
    else
      render :error
    end
  end
end
