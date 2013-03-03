# encoding: utf-8

class ProjectFilter < Filter
  def filter(projects)
    # projects = projects.search(search)  if search
    case params.deal_type
    when ['1']
      params.type = 'investments'
    when ['2']
      params.type = 'grants'
    end
    projects = projects.in_scopes(params.sector)      if params.sector
    projects = projects.in_round(round)               if round
    projects = projects.in_stage(stage)               if stage
    projects = projects.from_amount(params.amount_start.to_i)   if params.amount_start
    projects = projects.to_amount(params.amount_end.to_i)       if params.amount_end
    projects = projects.for_type(type)     if type
    projects = projects.sort_type(params.sort_type)

    projects
  end

  def type
    @type ||= params.type if types[params.type]
  end

  def type_name
    @type_name ||= types[type]
  end

  def types
    {
      nil           => "Все",
      "grants"      => "Гранты",
      "investments" => "Инвестиции",
    }
  end
end
