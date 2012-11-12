# encoding: utf-8

class DealDecorator < ApplicationDecorator
  decorates :deal

  def id
    "%06d" % deal.id
  end

  def project_name
    project.try(:name) || "—"
  end

  def amount
    return "—" unless deal.amount?
    roubles(deal.amount)
  end

  def contract_date
    return "—" unless deal.contract_date?
    h.localize(deal.contract_date)
  end

  def investor_names
    return "—" unless deal.investors.any?
    list deal.investors.map(&:name)
  end
end
