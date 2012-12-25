# encoding: utf-8

class Users::PasswordsController < Devise::PasswordsController
  layout "admin"

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
   nil
  end
end
