# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def after_sign_in_path_for(*)
    about_path
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
    method = input.respond_to?(:each) ? decorator.method(:decorate_collection) : decorator.method(:decorate)
    method.call(input, options)
  end
  helper_method :decorate

  def paginate(scope, per = 50)
    if scope.is_a?(Array) and not scope.is_a?(ThinkingSphinx::Search)
      scope = Kaminari.paginate_array(scope)
    end
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

  def markdown(text)
    return "" if text.blank?
    GitHub::Markdown.render_gfm(text).html_safe
  end
  helper_method :markdown
end
