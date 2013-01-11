class ErrorsController < ApplicationController
  include CabinetMenuIntegration

  layout 'errors'

  before_filter :init_menu

  def error_404
  end

  def error_500
  end

  private

  def init_menu
    @menu = CabinetMenu.new(view_context)
  end
end
