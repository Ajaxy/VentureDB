# encoding: utf-8

class StreamDealDecorator < DealDecorator
  decorates :deal

  def amount
    if deal.amount?
      tag :b, millions(deal.amount)
    else
      "неизвестную сумму"
    end
  end

  def date
    return unless deal.date
    h.localize deal.date, format: "%e %B %Y"
  end

  def description
    verb = deal.investors.size == 1 ? "инвестировал" : "инвестировали"
    h.raw "#{investor_links} #{verb} #{amount} #{round} в #{project_link}"
  end

  def investor_links
    return "Неизвестные инвесторы" if deal.investors.empty?
    deal.investors.map { |i| h.decorate(i).link }.to_sentence
  end

  def meta
    scopes    = deal.project ? deal.project.scopes : []
    locations = deal.investments.map { |inv| inv.locations }.reduce(:+) || []

    [*scopes.map(&:full_name), *locations.map(&:name).uniq].join(", ")
  end

  def project_link
    return "—" unless deal.project
    h.link_to project_name, deal.project
  end

  def round
    "(#{deal.round})" if deal.round
  end
end
