# encoding utf-8

module CabinetMenuIntegration
  extend ActiveSupport::Concern

  included do
    before_filter :init_menu
  end

  private

  def init_menu
    @menu = CabinetMenu.new(view_context)
  end
end
