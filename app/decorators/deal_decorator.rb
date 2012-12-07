# encoding: utf-8

class DealDecorator < ApplicationDecorator
  decorates :deal

  def id
    value = "%06d" % deal.id
    if deal.errors_log?
      errors = h.simple_format(deal.errors_log)
      tag :span, value, rel: "tooltip", title: errors, class: "errors_log"
    else
      value
    end
  end

  def project_name
    project.try(:name) || "—"
  end

  def round
    deal.round || "—"
  end

  def status
    deal.status || "—"
  end

  def amount
    return "—" unless deal.amount?
    tag :span, roubles(deal.amount), class: "amount"
  end

  def value_before
    return "—" unless deal.value_before?
    tag :span, roubles(deal.value_before), class: "amount"
  end

  def value_after
    return "—" unless deal.value_after?
    tag :span, roubles(deal.value_after), class: "amount"
  end

  def contract_date
    return "—" unless deal.contract_date?
    h.localize(deal.contract_date)
  end

  def announcement_date
    return "—" unless deal.announcement_date?
    h.localize(deal.announcement_date)
  end

  def investor_names
    return "—" unless deal.investors.any?
    list deal.investors.map(&:name)
  end

  def authors_list
    return "—" unless deal.project.authors.any?
    list project.authors.map(&:name)
  end
end
