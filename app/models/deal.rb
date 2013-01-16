# encoding: utf-8

class Deal < ActiveRecord::Base
  belongs_to :project
  belongs_to :informer, class_name: "Person"

  has_many :investments
  has_many :investors, through: :investments
  has_many :scopes, through: :project

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

  define_index do
    indexes project.name
    indexes project.company.name
    indexes project.authors.first_name
    indexes project.authors.last_name
    indexes investors.name

    has stage_id
    has round_id
    has investments.instrument_id, as: :type_id
    has scopes(:id), as: :scope_ids
    has "coalesce(deals.contract_date, deals.announcement_date)", as: :started_at,
      type: :datetime
    has amount_usd, type: :integer

    where "deals.published = 't'"
  end

  sphinx_scope(:in_stage) { |stage|
    { with: { stage_id: stage } }
  }

  sphinx_scope(:in_round) { |round|
    { with: { round_id: round } }
  }

  sphinx_scope(:for_type) { |type|
    ids = Investment::GRANT_INSTRUMENTS

    case type
    when "grants"
      { with: { type_id: ids } }
    when "investments"
      { without: { type_id: ids } }
    else
      raise ArgumentError
    end
  }

  sphinx_scope(:in_scope) { |scope|
    { with: { scope_ids: scope.id } }
  }

  sphinx_scope(:for_year) { |year|
    beginning_of_year = Date.new(year).beginning_of_year
    end_of_year       = Date.new(year).end_of_year
    { with: { started_at: beginning_of_year..end_of_year } }
  }

  sphinx_scope(:order_by_amount) { |direction|
    { order: :amount_usd, sort_mode: direction }
  }

  sphinx_scope(:order_by_started_at) { |direction|
    { order: :started_at, sort_mode: direction }
  }

  def self.published
    where{published == true}
  end

  def self.unpublished
    where{published == false}
  end

  def self.in_scope(scope)
    joins{project.scopes}
      .where{(scopes.lft >= scope.lft) & (scopes.lft < scope.rgt)}
  end

  def self.in_location(location)
    joins{investments.investor.locations}
      .where{(locations.lft >= location.lft) & (locations.lft < location.rgt)}
  end

  def self.in_stage(stage)
    return scoped unless Deal::STAGES[stage]
    where{stage_id == stage}
  end

  def self.in_round(round)
    return scoped unless Deal::ROUNDS[round]
    where{round_id == round}
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

  def self.from_amount(value)
    where{amount >= value}
  end

  def self.to_amount(value)
    where{amount <= value}
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
    project.try(:publish)
    investments.each(&:publish)
    informer.try(:publish)
    true
  end

  def publish
    errors.add :publish, "Не указан проект" unless project
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
