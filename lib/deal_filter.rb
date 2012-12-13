  # encoding: utf-8

class DealFilter < Filter
  LAST_YEARS = 3

  def filter(deals)
    deals = deals.in_stage(stage)             if stage
    deals = deals.in_round(round)             if round
    deals = deals.with_investor_type(params.investor.to_i)

    deals = deals.for_year(year)              if year
    deals = deals.in_scope(scope)             if scope
    deals = deals.from_date(date_start)       if date_start
    deals = deals.to_date(date_end)           if date_end
    deals = deals.from_amount(amount_start)   if amount_start
    deals = deals.to_amount(amount_end)       if amount_end
    deals = deals.search(params.search.strip) if params.search.present?

    deals
  end

  def deals
    filter(Deal.published)
  end

  def by_year
    year ? Deal.for_year(year) : Deal.published
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
