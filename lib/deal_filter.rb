  # encoding: utf-8

class DealFilter < Filter
  LAST_YEARS = 3

  def filter(deals)
    deals = deals.search(params.search.strip) if params.search.present?

    case params.deal_type
    when ['1']
      params.type = 'investments'
    when ['2']
      params.type = 'grants'
    end
    # deals = deals.with_investor_type(params.investor.to_i) if params.investor.present?
    # deals = deals.from_date(date_start)         if date_start
    # deals = deals.to_date(date_end)             if date_end

    deals = deals.in_scopes(params.sector)      if params.sector
    deals = deals.in_round(round)               if round
    deals = deals.in_stage(stage)               if stage
    deals = deals.for_year(year)                if year
    deals = deals.from_amount(params.amount_start.to_i)   if params.amount_start
    deals = deals.to_amount(params.amount_end.to_i)       if params.amount_end
    deals = deals.for_type(type)                if type
    deals = deals.sort_type(params.sort_type)     if params.sort_type

    deals
  end

  def deals
    filter(Deal.published)
  end

  def by_year(deals)
    deals = deals.for_year(year) if year
    deals
  end

  def amount(string)
    return unless string.present?

    string.gsub!(/[  ]/, "")
    string.sub!(",", ".")
    (string.to_f * 1_000_000).round
  end

  def amount_start
    amount(params.amount_start)
  end

  def amount_end
    amount(params.amount_end)
  end

  def date(string)
    return unless string.present?

    d, m, y = string.split(".")
    date = Date.new(y.to_i, m.to_i, d.to_i) rescue nil

    range = (Date.today - 100.years .. Date.today + 100.years)
    date if date && range.cover?(date)
  end

  def date_start
    date = date(params.date_start)
    params.date_start = nil unless date
    date
  end

  def date_end
    date = date(params.date_end)
    params.date_end = nil unless date
    date
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

  def year
    @year ||= begin
      year = params.year.to_i
      year if year.in?(start_year .. Time.current.year)
    end
  end

  def start_year
    Time.current.year - LAST_YEARS + 1
  end
end
