# encoding: utf-8

class Deal < ActiveRecord::Base
  belongs_to :project
  belongs_to :informer, class_name: "Person"

  has_many :investments
  has_many :investors, through: :investments

  STATUSES = {
    1 => "Планируемая",
    2 => "В процессе",
    3 => "Завершенная",
  }

  STAGES = {
    1 => "Pre-seed / Предпосев (до 50К)",
    2 => "Seed / Посев (до 500К)",
    3 => "Startup / Начальная (до 5М)",
    4 => "Earlygrowth / Ранний рост (до 10М)",
    5 => "Laterstages / Поздние стадии",
  }

  ROUNDS = {
    1 => "Посевной раунд (на предпосеве и посеве)",
    2 => "Первый (А) (на стадии стартап)",
    3 => "Второй (В) (на стадии раннего роста)",
    4 => "Поздние раунды (3-й 4-й 5-й и т.д.) (на поздних стадиях)",
    5 => "Выход (buyout, M&A, IPO) (на поздних стадиях)",
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
end
