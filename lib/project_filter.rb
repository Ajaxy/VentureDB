# encoding: utf-8

class ProjectFilter < Filter
  def filter(projects)
    projects = projects.search(search)  if search
    case params.deal_type
    when ['1']
      params.type = 'investments'
    when ['2']
      params.type = 'grants'
    end
    projects = projects.in_scopes(params.sector)      if params.sector
    projects = projects.in_rounds(params.round)       if params.round
    projects = projects.in_stages(params.stage)       if params.stage

    amount_start, amount_end = get_amount_vars params.amount_range.to_i
    if amount_start && amount_end
      projects = projects.in_amount_range amount_start.to_i,
                                    amount_end.to_i
    end

    projects = projects.for_type(type)                if type
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

  private

  def get_amount_vars(range)
    case range
    when 1
      return [0,50000]
    when 2
      return [50000,100000]
    when 3
      return [100000,250000]
    when 4
      return [250000,500000]
    when 5
      return [500000,1000000]
    when 6
      return [1000000,5000000]
    when 7
      return [5000000,2000000000]
    end
  end

end
