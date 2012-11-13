# encoding: utf-8

class Users::RegistrationsController < Devise::RegistrationsController
  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def after_inactive_sign_up_path_for(*)
    new_user_session_path
  end
end
