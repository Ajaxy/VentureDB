# encoding: utf-8

class Users::RegistrationsController < Devise::RegistrationsController
  layout "admin"

  private

  def resource_params
    permitted_params.user
  end
end
