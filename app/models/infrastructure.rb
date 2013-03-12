# encoding: utf-8
class Infrastructure < Company
  TYPES = {
    1 => "Сервисный провайдер, консалтинг",
    2 => "Ассоциация или бизнес-сообщество"
  }
  validates :type_id, inclusion: { in: TYPES.keys }, allow_nil: true
end