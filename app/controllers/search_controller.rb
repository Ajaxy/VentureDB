# encoding: utf-8

class SearchController < ApplicationController
  respond_to :json

  def suggest
    suggester = Suggester.new(params[:query], params[:entites])
    entites   = suggester.suggest

    respond_with(entites)
  end
end
