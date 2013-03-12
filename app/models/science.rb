# encoding: utf-8
class Science < Company
  TYPES = {
    1  => "Технопарк, ИТЦ",
    2  => "Вузовский центр",
    3  => "Бизнес-катализатор, бизнес-акселератор",
    4  => "Бизнес-инкубатор",
    5  => "ОЭЗ, технико-внедренческая зона, технополис",
    6  => "НИИ, центр прикладных исследований",
    7  => "Центр прототипирования и дизайна",
    8  => "Центр продвижения и трансфера технологий",
    9  => "Центр катализации (seed-house)",
    10 => "Центр коллективного пользования (ЦКП)",
    11 => "Парк: научный, научно-технологический, промышленный, бизнес-парк",
    12 => "Инновационный ВУЗ",
    13 => "Прочие образовательные центры (кроме ВУЗов) с программами по инновациям",
    14 => "Прочие центры Интернет-ресурсы"
  }
  validates :type_id, inclusion: { in: TYPES.keys }, allow_nil: true
end