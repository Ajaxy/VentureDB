# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, with: lambda { |exception| render_error 500, exception }
  rescue_from ActionController::RoutingError, ActionController::UnknownController,
    ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound,
    with: lambda { |exception| render_error 404, exception }

  private

  def render_error(status, exception)
    if Rails.env.production?
      # notify about exception anyway
      ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
    end

    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'errors',
        status: status }
      format.all { render nothing: true, status: status }
    end
  end

  def after_sign_in_path_for(*)
    deals_path
  end

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

  def paginate(scope, per = 50)
    scope = Kaminari.paginate_array(scope) if scope.is_a?(Array)
    scope.page(params[:page]).per(per)
  end

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end
  helper_method :permitted_params

  def raise_404
    raise ActionController::RoutingError.new("404")
  end

  def require_admin!
    unless current_user && current_user.admin?
      raise_404
    end
  end
end
