# encoding: utf-8

class Loader
  attr_reader :data
  attr_reader :errors

  def initialize(data)
    @data = data
    @errors = []
  end

  def load!
    attrs = {
      project:            get_project,
      approx_date:        approx_date?,
      announcement_date:  parse_date(data[:announcement_date]),
      contract_date:      parse_date(data[:contract_date]),
      status_id:          status,
      round_id:           round,
      stage_id:           stage,
      approx_amount:      approx_amount?,
      amount:             parse_amount(data[:amount]),
      value_before:       parse_amount(data[:value_before]),
      value_after:        parse_amount(data[:value_after]),
      informer:           informer,
      financial_advisor:  data[:financial_advisor],
      legal_advisor:      data[:legal_advisor],
      mentions:           data[:mentions],
      comments:           data[:comments],
      investments:        get_investments,
      errors_log:         errors.join("\n")
    }

    if errors.any?
      puts "Deal ##{data[:id]}"
      puts errors
      puts
    end

    Deal.create!(attrs)
  end

  private

  def approx_amount?
    data[:approx_amount] == "0"
  end

  def approx_date?
    data[:approx_date] == "нет"
  end

  def blank?(string)
    string.blank? || string.in?("Нет данных", "Нет двнных", "Не раскрывается",
                                "Не разкрывается", "Не разглашается")
  end

  def find_location(string)
    return if blank?(string)

    map = {
      "США" => "Соединенные Штаты",
      "Великобритания" => "Соединенное Королевство",
      "Белоруссия" => "Беларусь",
      "Британские Виргинские Острова" => "Британские Виргинские острова",
      "Каймановы Острова" => "Острова Кайман",
      "Каймановы острова" => "Острова Кайман",
      "Укараина" => "Украина",
      "Весь мир" => "Глобальный рынок",
      "Остров Джерси" => "Джерси",
      "Маунтин Вью" => "Соединенные Штаты",
      "Шверцария" => "Швейцария",
      "Санкт-петербург" => "Санкт-Петербург",
      "Киев" => "Украина",
      "Рига" => "Латвия",
      "Житомир" => "Украина",
      "Калифорния" => "Соединенные Штаты",
      "страны СНГ" => "Страны СНГ",
    }

    string = map[string] if map[string]

    location = Location.where{(name == string) | (full_name == string)}.first
    errors << "Локация не найдена: #{string.inspect}" unless location
    location
  end

  def get_company
    return if blank?(data[:company_name])

    if company = Company.where(name: data[:company_name]).first
      company
    else
      Company.create!(
        name:       data[:company_name],
        full_name:  data[:company_full_name],
        locations:  parse_locations(data[:company_location]),
        form:       data[:company_form],
        place:      data[:company_place],
      )
    end
  end

  def get_investments
    names       = parse_array data[:investor_names]
    types       = parse_array data[:investor_types]
    locations   = parse_array data[:investor_locations]
    instruments = parse_array data[:investment_instruments]
    shares      = parse_array data[:investment_shares]

    sizes = [names.size, types.size, locations.size, instruments.size, shares.size]
    sizes.delete(0)
    sizes.delete(1)

    if sizes.uniq.size > 1
      errors << "Не удалось разобрать информацию об инвесторах"
      return []
    end

    names.size.times.map do |i|
      name         = names[i]
      type         = types[i]
      location     = locations[i]
      instrument   = instruments[i] || instruments.first
      share        = shares[i]      || shares.first

      Investment.create!(
        investor:       get_investor(name, type, location),
        instrument_id:  parse_instrument(instrument),
        share:          share,
      )
    end
  end

  def get_investor(name, type, location)
    type = parse_investor_type(type)

    if blank?(name)
      return Investor.create!(actor: nil, type_id: type)
    end

    actor = if type.in?(10, 12)
      parts = name.split
      case parts.size
      when 2
        first_name, last_name = parts
      when 3
        last_name, first_name, middle_name = parts
      else
        last_name = parts.pop
        first_name = parts.join(" ")
      end

      if person = Person.where(first_name: first_name, last_name: last_name).first
        person
      else
        Person.create!(
          first_name:   first_name,
          last_name:    last_name,
          middle_name:  middle_name,
          locations:    parse_locations(location),
        )
      end
    else
      if company = Company.where(name: name).first
        company
      else
        Company.create!(name: name, locations: parse_locations(location))
      end
    end

    Investor.create!(actor: actor, type_id: type)
  end

  def get_project
    if project = Project.where(name: data[:project_name]).first
      project
    else
      Project.create!(
        name:         data[:project_name],
        description:  data[:project_description],
        company:      get_company,
        authors:      project_authors,
        markets:      parse_locations(data[:project_markets]),
        scopes:       project_scopes,
      )
    end
  end

  def informer
    return unless info = data[:informer_info]

    names  = []
    phones = []
    emails = []

    info.split("\n").each do |field|
      case field
      when /^[А-ЯЁ]/
        names  << field
      when /^[\d ()+-]{7}/
        phones << field
      when /^http/, /@/
        emails << field
      else
        errors << "Не удалось распознать информацию об информаторе: #{field.inspect}"
      end
    end

    first_name, last_name = names.first.split

    if person = Person.where(first_name: first_name, last_name: last_name).first
      return person
    end

    Person.create!(
      first_name: first_name,
      last_name:  last_name,
      phone:      phones.join("\n"),
      email:      emails.join("\n"),
    )
  end

  def parse_amount(amount)
    return unless amount =~ /\d/
    amount.gsub(/\D/, "").to_i
  end

  def parse_array(string)
    return [] unless string
    string.split("\n")
  end

  def parse_date(date)
    return unless date
    m, d, y = date.split("/")
    begin
      Time.new(y, m, d).to_date
    rescue
      errors << "Недопустимый формат даты #{date}"
      nil
    end
  end

  def parse_instrument(string)
    return if blank?(string)

    values = {
      "Обыкновенные акции" => 1,
      "Обыкновенная акции" => 1,
      "Обкновенные акции" => 1,
      "Привилегированные акции" => 2,
      "Опционы и варранты" => 3,
      "Кредиты" => 4,
      "Векселя" => 5,
      "Конвертируемые инструменты" => 6,
      "Лизинг" => 7,
      "Грант" => 8,
      "Субсидия" => 9,
      "Прочие" => 10,
      "Прочие - приобретение технологии" => 10,
      "Прочие /приобретение технологии" => 10,
      "Прочие/приобретение технологии" => 10,
      "Прочие - объединение компаний" => 10,
      "Прочие/объединение компаний" => 10,
    }

    errors << "Не найден финансовый инструмент: #{string.inspect}" unless values[string]
    values[string]
  end

  def parse_investor_type(string)
    return if blank?(string)

    values = {
      "Государственный фонд/организация" => 1,
      "Государственный фонд / организация" => 1,
      "Государственный фонд" => 1,
      "Государственная корпорация" => 1,
      "Государственная корпорвция" => 1,
      "Государственная организация" => 1,
      "Корпорация" => 2,
      "Корпоративный венчурный фонд" => 3,
      "Частный венчурный фонд" => 4,
      "Частные венчурные фонды" => 4,
      "Частный фенчурный фонд" => 4,
      "Частный фвенчурный фонд" => 4,
      "Часстный венчурный фонд" => 4,
      "Фонд прямых инвестиций" => 5,
      "Фонд фондов" => 6,
      "Инвестиционный банк" => 7,
      "Инвестиционная компания" => 8,
      "Инвеcтиционная компания" => 8,
      "Прочие институциональные инвесторы" => 9,
      "Прочие институциональые инвесторы" => 9,
      "Прочие инстициональные инвесторы" => 9,
      "Прочие институциональные инвесторы/хедж-фонд" => 9,
      "Прочие институциональные инвесторы - хедж-фонд" => 9,
      "Бизнес-ангел" => 10,
      "Бизнес-ангелы" => 10,
      "Прочие фонды" => 11,
      "Прочие физлица (включая FFF)" => 12,
      "Прочие организации (юрлица)" => 13,
      "Прочие организации" => 13,
    }

    errors << "Не найден тип инвестора: #{string.inspect}" unless values[string]
    values[string]
  end

  def parse_locations(string)
    return [] if blank?(string)

    string.gsub!("Литва и Латвия", "Литва, Латвия")
    string.gsub!("Москва и Московская область", "Москва, Московская область")
    string.gsub!("Белоруссия и другие страны СНГ", "Белоруссия, страны СНГ")
    string.gsub!("Россия и страны СНГ", "Россия, страны СНГ")
    string.gsub!(/\(.+?\)/, "")

    string.split(/[,\n]/).map { |location| find_location(location.strip) }.compact
  end

  def project_authors
    authors = data[:project_authors]
    return [] if blank?(authors)

    names   = authors.split("\n")
    emails  = data[:project_authors_contacts]

    names.map do |name|
      first_name, last_name = name.split
      unless last_name
        errors << "Недопустимое имя автора проекта: #{name}"
      end
      if person = Person.where(first_name: first_name, last_name: last_name).first
        person
      else
        Person.create!(first_name: first_name, last_name: last_name, email: emails)
      end
    end.compact
  end

  def project_scopes
    info = data[:project_scopes]
    return [] if blank?(info)

    scopes = []

    map = {
      "Социальные сети и сообщества" => "Социальные сети/сообщества",
      "Традиционная энергетика и топливо" => "Традиционная энергетика (гидроэнергетика, тепловая энергетика, атомная энергетика) и топливо",
      "Сервисные и Прочее инновационные технологии" => "Сервисные и прочие инновационные технологии",
      "Miobile" => "Mobile",
      "Mibile" => "Mobile",
      "Справочный и рекомендательный сервис" => "Справочный/Рекомендательный сервис",
      "IP-телефония и передача данных" => "IP-телефония/передача данных",
      "Тедекоммуникации" => "Телекоммуникации",
      "Справочный, рекомендательный сервис" => "Справочный/Рекомендательный сервис",
      "Традичионная энергетика и топливо" => "Традиционная энергетика (гидроэнергетика, тепловая энергетика, атомная энергетика) и топливо",
    }

    info.gsub!("СМИ;Медиа и Развлечения", "СМИ, медиа и развлечения")
    info.gsub!("Экологически чисты технологии - Альтернативные и возобновляемые источники энергии", "Экологически чистые технологии/Альтернативные и возобновляемые источники энергии",)
    info.gsub!("Облачные технологии, Финансы", "Облачные технологии;Финансы",)
    info.gsub!("Рекламные технологии, Развлечения", "Рекламные технологии;Развлечения",)

    current_root = nil

    info.split(/[\n;]/).each do |part|
      levels = part.split("/")

      if levels.size == 1
        name = levels.first
        name = map[name] if map[name]

        if scope = Scope.roots.where(name: name).first
          scopes << scope
        else
          if current_root && scope = current_root.descendants.where(name: name).first
            scopes << scope
          else
            errors << "Не найдена сфера деятельности #{name.inspect}"
          end
        end
      else
        # more than 1 level
        root_name = levels.first
        root_name = map[root_name] if map[root_name]

        if root = Scope.where(name: root_name).first
          current_root = root

          name = levels.last
          name = map[name] if map[name]

          if scope = root.descendants.where(name: name).first
            scopes << scope
          else
            errors << "Не найдена сфера деятельности #{name.inspect} в #{root.name.inspect}"
          end
        else
          errors << "Не найдена сфера деятельности #{root_name.inspect}"
        end
      end
    end

    scopes
  end

  def round
    return unless string = data[:round]

    values = {
      "Посевной"          => 1,
      "Раунд А"           => 2,
      "Раунд A"           => 2,
      "Раунд Б"           => 3,
      "Раунд B"           => 3,
      "Раунд С"           => 4,
      "Раунд C"           => 4,
      "Раунд D"           => 4,
      "Раунд Е"           => 4,
      "Раунд E"           => 4,
      "IPO"               => 5,
      "Выход"             => 5,
      # "Покупка компании"  => ?,
    }

    errors << "Не найден раунд сделки: #{string.inspect}" unless values[string]
    values[string]
  end

  def stage
    return unless string = data[:stage]

    values = {
      "Pre-seed/Предпосев"        => 1,
      "Seed/Посев"                => 2,
      "Startup/Начальная"         => 3,
      "Earlygrowth/Ранний рост"   => 4,
      "Early growth/Ранний рост"  => 4,
      "Expansion/Расширение"      => 5,
    }

    errors << "Не найдена стадия сделки: #{string.inspect}" unless values[string]
    values[string]
  end

  def status
    return unless string = data[:status]

    values = {
      "анонсированная"  => 1,
      "в процессе"      => 2,
      "завершенная"     => 3,
    }

    errors << "Не найден статус сделки: #{string.inspect}" unless values[string]
    values[string]
  end
end
