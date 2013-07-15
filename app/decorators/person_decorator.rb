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
    upcase Plans.get(plan).title
  end

  def plan_ends_at
    h.localize(plan_started_at ? (plan_started_at + Plans.get(plan).duration).to_date : Date.yesterday)
  end

  def plan_rest
    plan_active > 0 ? (plan_active / 60 / 60 / 24).floor : 'Истёк!'
  end
end
