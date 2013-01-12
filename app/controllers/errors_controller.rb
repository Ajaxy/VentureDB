class ErrorsController < ApplicationController
  include CabinetMenuIntegration

  layout 'errors'

  before_filter :init_menu

  def error_404
    render status: 404
  end

  def error_500
  end
end
