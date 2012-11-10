# encoding: utf-8

class CompaniesController < ApplicationController
  def index
    render :new
  end

  def new
    @company = Company.new
  end
end
