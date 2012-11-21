# encoding: utf-8

class DealDecorator < ApplicationDecorator
  decorates :deal

  def id
    value = "%06d" % deal.id
    if deal.errors_log?
      errors = deal.errors_log.gsub("\n", "; ")
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
    tag :div, roubles(deal.amount), class: "amount"
  end

  def contract_date
    return "—" unless deal.contract_date?
    h.localize(deal.contract_date)
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
