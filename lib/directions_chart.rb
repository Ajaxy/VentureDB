# encoding: utf-8

class DirectionsChart
  attr_reader :id
  attr_reader :scopes

  def initialize(id)
    @id = id
    @scopes ||= get_scopes.select { |s| s.deals.any? }.sort_by(&:count).reverse
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
    ids = deals
    Investor.joins{deals}.where{deals.id.in(ids)}.select{distinct id}.size
  end

  def projects
    ids = deals
    Project.joins{deals}.where{deals.id.in(ids)}.select{distinct id}.size
  end

  def title
    if id
      "Направления инвестиций в сфере «#{current_scope.name}»"
    else
      "Направления инвестиций"
    end
  end

  private

  def current_scope
    scope = Scope.find(id)
    raise ArgumentError.new if scope.leaf?
    scope
  end

  def deals
    scopes.sum(&:deals).uniq
  end

  def get_data
    data = []
    data << ["Sector", "Deals"]

    scopes.each_with_index do |scope, index|
      data << [scope.name, scope.count]
    end

    data
  end

  def get_scopes
    real_scopes.map do |scope|
      ids   = scope.self_and_descendants.pluck(:id)
      scope.deals = Deal.joins{project.project_scopes}
                        .where{project_scopes.scope_id.in(ids)}
                        .select{[id, amount]}
      scope
    end
  end

  def real_scopes
    id ? current_scope.children : Scope.roots
  end
end
