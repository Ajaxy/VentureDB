# encoding: utf-8

class PeopleController < ApplicationController
  before_filter :require_admin!

  def show
    @person = Author.find(params[:id])
    @type   = "author"
    render :success
  end

  def create
    @type   = params[:type]

    klass   = @type == "author" ? Author : Informer
    @person = klass.find_or_create_draft(permitted_params.person)

    if @person.valid?
      render :success
    else
      render :error
    end
  end
end
