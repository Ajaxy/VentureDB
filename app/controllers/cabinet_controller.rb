# encoding: utf-8

class CabinetController < ApplicationController
  before_filter :authenticate_user!
  before_filter :init_menu

  private

  def init_menu
    @menu = CabinetMenu.new(view_context)
  end
end
