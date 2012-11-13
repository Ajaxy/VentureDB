# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  private

  def decorate(input, options = {})
    if input.respond_to?(:klass)
      klass = input.klass.name
    elsif input.respond_to?(:each)
      return input if input.size == 0
      klass = input.first.class.name
    else
      klass = input.class.name
    end

    decorator = "#{klass}Decorator".constantize rescue ApplicationDecorator
    decorator.decorate(input, options)
  end
  helper_method :decorate

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end
  helper_method :permitted_params

  def require_admin!
    raise ActionController::RoutingError.new("404") unless current_user.admin?
  end
end
