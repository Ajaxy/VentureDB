# encoding: utf-8

class DirectionsChart
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def amount
    scopes.sum(&:amount)
  end

  def count
    scopes.sum(&:count)
  end

  def data
    get_data.to_json
  end

  def investors
    ids = deals.map(&:id)
    Investment.where{deal_id.in(ids)}.uniq.pluck(:investor_id).size
  end

  def options
    {}
  end

  def projects
    deals.map(&:project_id).uniq.length
  end

  def scopes
    @scopes ||= get_scopes.select { |s| s.deals.any? }.sort_by(&:count).reverse
  end

  def title
    if id
      "Направления инвестиций в сфере «#{current_scope.name}»"
    else
      "Направления инвестиций"
    end
  end

  def type
    "PieChart"
  end

  private

  def current_scope
    scope = Scope.find(id)
    raise ArgumentError.new if scope.leaf?
    scope
  end

  def deals
    scopes.sum(&:deals)
  end

  def get_data
    data = scopes.map { |scope| [scope.name, scope.count] }
    data.prepend ["Sector", "Deals"]
    data
  end

  def get_scopes
    id ? current_scope.children : Scope.roots
  end
end
