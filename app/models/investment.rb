# encoding: utf-8

class Investment < ActiveRecord::Base
  include Draftable

  belongs_to :investor
  belongs_to :deal

  # validates :investor_id, :instrument_id, :share, presence: true
  delegate :name, :type, to: :investor, prefix: true, allow_nil: true

  INSTRUMENTS = {
    1  => "Обыкновенные акции",
    2  => "Привилегированные акции",
    3  => "Опционы и варранты",
    4  => "Кредиты",
    5  => "Векселя",
    6  => "Конвертируемые инструменты",
    7  => "Лизинг",
    8  => "Грант",
    9  => "Субсидия",
    10 => "Прочие",
  }

  def instrument
    INSTRUMENTS[instrument_id]
  end

  def publish
    super
    investor.try(:publish)
  end

  def locations
    investor ? investor.locations : []
  end
end

