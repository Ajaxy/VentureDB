# encoding: utf-8

class Deal < ActiveRecord::Base
  belongs_to :project # deprecated
  belongs_to :company

  has_many :investments
  has_many :investors, through: :investments
  has_many :scopes, through: :company

  DEAL_TYPES = {
    1 => "Инвестиции",
    2 => "Гранты"
  }

  STATUSES = {
    1 => "Анонсированная",
    2 => "В процессе",
    3 => "Завершенная",
  }

  STAGES = {
    1 => "Посев",
    2 => "Стартап",
    3 => "Рост",
    4 => "Экспансия",
    5 => "Публичная компания",
  }

  ROUNDS = {
    1 => "Посевной раунд",
    2 => "Раунд A",
    3 => "Раунд B",
    4 => "Раунд C+",
    5 => "Выход",
  }

  ROUNDS_SHORT = {
    1 => "Посев",
    2 => "A",
    3 => "B",
    4 => "C+",
    5 => "Выход",
  }

  EXIT_TYPES = {
    1 => "MBO",
    2 => "LBO",
    3 => "Слияние",
    4 => "Поглощение",
    5 => "IPO",
  }

  define_index "deals_index" do
    indexes company.name
    indexes project.company.name
    indexes project.authors.first_name
    indexes project.authors.last_name
    indexes investors.name

    where "deals.published = 't'"
  end

  define_index "deals_prefix_index" do
    indexes company.name
    indexes project.company.name
    indexes project.authors.first_name
    indexes project.authors.last_name
    indexes investors.name

    where "deals.published = 't'"
    set_property min_prefix_len: 3
  end

  include Searchable

  def self.published
    where{published == true}
  end

  def self.unpublished
    where{published == false}
  end

  def self.in_scope(scope)
    joins{company.scopes}
      .where{(scopes.lft >= scope.lft) & (scopes.lft < scope.rgt)}
  end

  def self.in_scopes(scope_arr)
    joins{company.scopes}
      .where{published == true}
      .where{scopes.id.in scope_arr}
  end

  def self.in_location(location)
    joins{investments.investor.locations}
      .where{(locations.lft >= location.lft) & (locations.lft < location.rgt)}
  end

  def self.in_stage(stage)
    return scoped unless Deal::STAGES[stage]
    where{stage_id == stage}
  end

  def self.in_stages(stages)
    where{(stage_id.in stages) & (deals.published == true)}
  end

  def self.in_round(round)
    return scoped unless Deal::ROUNDS[round]
    where{round_id == round}
  end

  def self.in_rounds(rounds)
    where{(round_id.in rounds) & (deals.published == true)}
  end

  def self.with_investor_type(type)
    return scoped unless Investor::TYPES[type]
    joins{investors}.where{investors.type_id == type}
  end

  def self.from_date(value)
    where{contract_date >= value}
  end

  def self.to_date(value)
    where{contract_date <= value}
  end

  def self.in_amount_range(from, to)
    where{(amount_usd >= from) & (amount_usd <= to)}
  end

  def self.from_amount(value)
    where{amount_usd >= value}
  end

  def self.to_amount(value)
    where{amount_usd <= value}
  end

  def self.for_period(period)
    where{coalesce(contract_date, announcement_date) >= period.begin}.
    where{coalesce(contract_date, announcement_date) <= period.end}
  end

  def self.for_year(year)
    for_period(Date.new(year) .. Date.new(year).end_of_year)
  end

  def self.for_type(type)
    ids = Investment::GRANT_INSTRUMENTS

    case type
    when "grants"
      joins{investments}.where{investments.instrument_id.in ids}
    when "investments"
      joins{investments}.where{coalesce(investments.instrument_id, 0).not_in ids}
    else
      raise ArgumentError
    end
  end

  def self.sort_type(type)
    case type
    when '2'
      order_by_amount('DESC')
    else
      order_by_started_at('DESC')
    end
  end

  def self.order_by_amount(direction)
    order("amount_usd #{direction} nulls last")
  end

  def self.order_by_started_at(direction)
    select("deals.*, coalesce(contract_date, announcement_date) AS date")
      .order("date #{direction}")
  end

  def amount
    amount_usd
  end

  def amount?
    amount_usd?
  end

  def announcement_date_before_type_cast
    return unless date = self[:announcement_date]
    I18n.localize(date)
  end

  def contract_date_before_type_cast
    return unless date = self[:contract_date]
    I18n.localize(date)
  end

  def is_grant?
    investments.any? { |inv| inv.is_grant? }
  end

  def status
    STATUSES[status_id]
  end

  def round
    ROUNDS[round_id]
  end

  def stage
    STAGES[stage_id]
  end

  def date
    contract_date || announcement_date
  end

  def exit_type
    EXIT_TYPES[exit_type_id]
  end

  def exit_type_id=(val)
    val = nil unless round_id == 7
    super(val)
  end

  def undraft
    company.try(:publish)
    investments.each(&:publish)
    true
  end

  def publish
    errors.add :publish, "Не указан проект" unless company
    errors.add :publish, "Не указан раунд инвестиций" unless round
    errors.add :publish, "Не указана стадия развития компании" unless stage
    errors.add :publish, "Не указана дата сделки" unless date
    errors.add :publish, "Не указана стоимость" unless amount
    errors.add :publish, "Лог ошибок не пуст" if errors_log?

    errors.add :publish, "Не указано инвестиций" unless investments.any?

    investments.each do |inv|
      errors.add :publish, "Не указан инвестор" unless inv.investor
    end

    update_attribute :published, errors.empty?
    errors.empty?
  end

  def unpublish
    update_attribute :published, false
  end
end
