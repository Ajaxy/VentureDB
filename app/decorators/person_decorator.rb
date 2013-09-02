# encoding: utf-8

class PersonDecorator < ApplicationDecorator
  decorates :person

  def type
    Person::TYPES[source.type_id]
  end

  def edit_path
    if source.investor?
      [:edit, :admin, investors.first]
    else
      super
    end
  end

  def legal_info
    "<b>Компания:</b> #{legal_title}<br/><b>Адрес:</b> #{legal_address}<br/><b>ОГРН:</b> #{legal_ogrn}<br/><b>ИНН:</b> #{legal_inn}"
  end

  def plan_title
    upcase Plans.get(plan).title_ru
  end

  def plan_rest
    plan_active ? ((object.plan_ends_at - Time.now) / 60 / 60 / 24).floor : 'Срок истёк!'
  end
end
