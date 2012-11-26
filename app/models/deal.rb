# encoding: utf-8

class Deal < ActiveRecord::Base
  belongs_to :project
  belongs_to :informer, class_name: "Person"

  has_many :investments
  has_many :investors, through: :investments

  validates :project_id, :amount, :investments, presence: true

  STATUSES = {
    1 => "Анонсированная",
    2 => "В процессе",
    3 => "Завершенная",
  }

  STAGES = {
    1 => "Pre-seed / Предпосев",
    2 => "Seed / Посев",
    3 => "Startup / Начальная",
    4 => "Early growth / Ранний рост",
    5 => "Expansion / Расширение",
    6 => "Mezzanine / Мезонин",
    7 => "Exit / Выход",
  }

  ROUNDS = {
    1 => "Посевной раунд",
    2 => "Раунд A",
    3 => "Раунд B",
    4 => "Раунд C",
    5 => "Раунд D",
    6 => "Раунд E",
    7 => "Выход",
  }

  EXIT_TYPES = {
    1 => "MBO",
    2 => "LBO",
    3 => "Слияние",
    4 => "Поглощение",
    5 => "IPO",
  }

  def self.in_scope(scope)
    joins{project.scopes}.where{(project.scopes.lft >= scope.lft) &
                                (project.scopes.lft < scope.rgt)}
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

  def self.search(string)
    return scoped unless string.present?
    search = "%#{string}%"
    joins{[ project.company.outer, project.authors.outer ]}
    .where{ project.name.like(search) |
            project.company.name.like(search) |
            project.authors.first_name.like(search) |
            project.authors.last_name.like(search) }
  end

  def self.for_period(period)
    where{coalesce(contract_date, announcement_date) >= period.begin}.
    where{coalesce(contract_date, announcement_date) <= period.end}
  end

  def self.for_year(year)
    for_period(Date.new(year) .. Date.new(year).end_of_year)
  end

  def announcement_date_before_type_cast
    return unless date = self[:announcement_date]
    I18n.localize(date)
  end

  def contract_date_before_type_cast
    return unless date = self[:contract_date]
    I18n.localize(date)
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

  def exit_type
    EXIT_TYPES[exit_type_id]
  end

  def exit_type_id=(val)
    val = nil unless round_id == 7
    super(val)
  end

  %w[amount value_before value_after].each do |attr|
    define_method "#{attr}=" do |val|
      val = val.gsub(/[  ]/, "") if val.respond_to?(:gsub)
      super(val)
    end
  end

  %w[euro_rate dollar_rate].each do |attr|
    define_method "#{attr}=" do |val|
      if val.is_a?(String) && val.present?
        val = val.sub(",", ".") if val.respond_to?(:gsub)
        val = (val.to_f.round(2) * 100).round
      end
      super(val)
    end

    define_method attr do
      return unless self[attr]
      self[attr] / 100.0
    end

    alias_method "#{attr}_before_type_cast", attr
  end

  def publish
    project.try(:publish)
    investments.each(&:publish)
    informer.try(:publish)
    true
  end
end
