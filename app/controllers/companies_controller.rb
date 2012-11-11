# encoding: utf-8

class CompaniesController < ApplicationController
  respond_to :js, except: :index

  def create
    @company = Company.find_or_create(params[:company], current_user)

    if @company.valid?
      render :success
    else
      render :error
    end
  end
end
