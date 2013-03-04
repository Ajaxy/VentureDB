# encoding: utf-8

class Filter
  attr_reader :params

  def initialize(params)
    @params = OpenStruct.new(params)
  end

  def search
    params.search.to_s.strip.presence
  end

  def round
    @round ||= begin
      val = params.round.to_i
      val if Deal::ROUNDS[val]
    end
  end

  def round_name
    rounds[round]
  end

  def rounds
    @rounds ||= { nil => "Все раунды" }.merge(Deal::ROUNDS)
  end

  def scope
    @scope ||= Scope.where(id: params.scope.to_i).first if params.scope.present?
  end

  def deal_type
    @deal ||= begin
      val = params.deal_type.to_i
      val if Deal::DEAL_TYPES[val]
    end
  end

  def deal_types
    @deals ||= { nil => "Все типы" }.merge(Deal::DEAL_TYPES)
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

  def stage
    @stage ||= begin
      val = params.stage.to_i
      val if Deal::STAGES[val]
    end
  end

  def stage_name
    stages[stage]
  end

  def stages
    @stages ||= { nil => "Все стадии" }.merge(Deal::STAGES)
  end
end
