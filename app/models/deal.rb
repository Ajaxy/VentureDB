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
    STATUSES[round_id]
  end

  def stage
    STATUSES[stage_id]
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
