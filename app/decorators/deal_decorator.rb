# encoding: utf-8

class DealDecorator < ApplicationDecorator
  decorates :deal

  def id
    value = "%06d" % deal.id

    if deal.errors_log?
      errors = h.simple_format(h.html_escape deal.errors_log)
      tag :span, value, rel: "tooltip", title: errors, class: "errors_log"
    else
      value
    end
  end

  def project_name
    company.try(:name) || mdash
  end

  def round
    if is_grant?
      "Грант"
    else
      deal.round || mdash
    end
  end

  def status
    deal.status || mdash
  end

  def amount
    return mdash unless deal.amount?
    tag :span, dollars(deal.amount), class: "amount"
  end

  def value_before
    return mdash unless deal.value_before?
    tag :span, dollars(deal.value_before), class: "amount"
  end

  def value_after
    return mdash unless deal.value_after?
    tag :span, dollars(deal.value_after), class: "amount"
  end

  def contract_date
    return mdash unless deal.contract_date?
    h.localize(deal.contract_date)
  end

  def announcement_date
    return mdash unless deal.announcement_date?
    h.localize(deal.announcement_date)
  end

  def investor_names
    return mdash unless deal.investors.any?
    list deal.investors.map(&:name)
  end

  def authors_list
    return mdash unless deal.project.authors.any?
    list project.authors.map(&:name)
  end

  def description_amount
    if deal.amount?
      (" " + tag(:b, dollars(deal.amount))).html_safe
    else
      ". Сумма сделки не разглашается."
    end
  end

  def description_grant_amount
    if deal.amount?
      " в размере " + tag(:b, dollars(deal.amount))
    else
      ". Сумма гранта не разглашается."
    end
  end

  def description_verb
    if deal.is_grant?
      deal.investors.size == 1 ? "выдал грант" : "выдали грант"
    else
      deal.investors.size == 1 ? "инвестировал" : "инвестировали"
    end
  end

  def date
    return unless deal.date
    h.localize deal.date, format: "%e %B %Y"
  end

  def description
    if deal.is_grant?
      h.raw "#{investor_links} #{description_verb} проекту #{project_link}#{description_grant_amount}"
    else
      h.raw "#{investor_links} #{description_verb} в #{project_link}#{description_amount}"
    end
  end

  def investor_links
    return "Неизвестные инвесторы" if deal.investors.empty?
    deal.investors.map { |i| i.decorate.link }.to_sentence.html_safe
  end

  def meta
    if deal.company && scope = deal.company.scopes.first
      scope.full_name
    end
  end

  def project_link
    return mdash unless deal.project
    h.link_to project_name, deal.company
  end

  def details_link
    return mdash unless deal.company
    h.link_to 'Детали сделки', deal.company
  end

  def share
    value = source.share
    value.zero? || value.blank? ? mdash : "#{value} %"
  end

  private

  def deal; source; end
end
