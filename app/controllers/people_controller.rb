# encoding: utf-8

class PeopleController < ApplicationController
  before_filter :require_admin!

  def show
    @person = Person.find(params[:id])
    render :success
  end

  def create
    @person = Person.find_or_create(permitted_params.person)

    if @person.valid?
      render :success
    else
      render :error
    end
  end
end
