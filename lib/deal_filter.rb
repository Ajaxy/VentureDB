  # encoding: utf-8

class DealFilter < Filter
  LAST_YEARS = 3

  def self.start_year
    Time.current.year - LAST_YEARS + 1
  end

  def filter(deals)
    #deals = deals.search(search) if search

    #deals = deals.in_scopes(params.sector)      if params.sector
    #deals = deals.in_rounds(params.round)       if params.round
    #deals = deals.in_stages(params.stage)       if params.stage
    deals = deals.for_year(year, params.quarter)   if year

    if params.amount_from || params.amount_to
      deals = deals.in_amount_range params.amount_from || 0,
                                    params.amount_to || Float::INFINITY
    end

    deals = deals.for_type('investments') if params.formats && params.formats.include?('1')
    deals = deals.for_type('grants') if params.formats && params.formats.include?('2')
    deals = deals.without_approx_amount if params.amount_without_approx
    deals = deals.without_empty_amount if params.amount_without_empty
    #deals = deals.sort_type(params.sort_type)

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
    DealFilter.start_year
  end

  def sort_types
    [['Дате', 1], ['Сумме', 2]]
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
