# encoding: utf-8

class Investment < ActiveRecord::Base
  include Draftable

  belongs_to :investor_entity, polymorphic: true

  belongs_to :investor, class_name: 'ViewInvestor', foreign_key: 'uniq_investor_id', primary_key: 'uniq_id'
  belongs_to :deal

  # def investor_entity_type=(sType)
  #    super(sType.to_s.classify.constantize.base_class.to_s)
  # end

  # validates :investor_id, :instrument_id, :share, presence: true
  # delegate :name, :type, to: :investor, prefix: true, allow_nil: true

  GRANT_INSTRUMENTS = [8, 9]

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

  def is_grant?
    GRANT_INSTRUMENTS.include? instrument_id
  end

  def publish
    super
    investor.try(:publish)
  end

  def locations
    investor_entity ? investor_entity.locations : []
  end
end

