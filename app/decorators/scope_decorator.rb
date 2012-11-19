# encoding: utf-8

class ScopeDecorator < ApplicationDecorator
  decorates :scope

  def amount
    roubles scope.amount.round(-6)
  end

  def link_or_name
    scope.leaf? ? scope.name : h.link_to(scope.name, id: scope.id)
  end
end
