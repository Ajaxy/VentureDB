# encoding: utf-8

class Users::SessionsController < Devise::SessionsController
  layout "admin"

  def new
    redirect_to '/login'
  end
end
