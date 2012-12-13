# encoding: utf-8

class Filter
  attr_reader :params

  def initialize(params)
    @params = OpenStruct.new(params)
  end

  def search
    params.search.to_s.strip.presence
  end

  def scope
    @scope ||= Scope.where(id: params.scope.to_i).first if params.scope.present?
  end

  def scope_name
    @scope_name ||= scope ? scope.name : "Все секторы"
  end

  def scopes
    @scopes ||= begin
      roots = ::Scope.roots.order(:name).to_a
      [OpenStruct.new(name: "Все секторы", id: nil), *roots]
    end
  end
end
