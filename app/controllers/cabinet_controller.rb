# encoding: utf-8

class CabinetController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plan_status
  before_filter :init_menu

  layout 'cabinet'

  private

  def check_plan_status
    unless current_user.person.plan_active || controller_name == 'account' then
      redirect_to '/account'
    end
  end

  def init_menu
    @menu = CabinetMenu.new(view_context)
  end
end
