# encoding: utf-8

class PeopleController < ApplicationController
  def index
    render :new
  end

  def new
    @person = Person.new
  end
end
