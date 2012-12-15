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
    project.try(:name) || mdash
  end

  def round
    deal.round || mdash
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
end
