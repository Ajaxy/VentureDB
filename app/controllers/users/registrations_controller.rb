# encoding: utf-8

class Users::RegistrationsController < Devise::RegistrationsController
  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
