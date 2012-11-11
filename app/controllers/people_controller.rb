# encoding: utf-8

class PeopleController < ApplicationController
  def show
    @person = Person.find(params[:id])
    render :success
  end

  def create
    @person = Person.find_or_create(params[:person])

    if @person.valid?
      render :show
    else
      render :error
    end
  end
end
