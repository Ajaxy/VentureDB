# encoding: utf-8

class SearchResultsDecorator < PaginatingDecorator
  protected

  def decorate_item(item)
    decorator_klass = item.is_a?(Deal) ? StreamDealDecorator.method(:decorate) : item_decorator
    decorator_klass.call(item, context: context)
  end
end
