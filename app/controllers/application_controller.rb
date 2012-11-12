class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  private

  def permitted_params
    @permitted_params ||= PermittedParams.new(params)#, current_user)
  end
  helper_method :permitted_params

  def require_admin!
    raise ActionController::RoutingError.new("404") unless current_user.admin?
  end
end
