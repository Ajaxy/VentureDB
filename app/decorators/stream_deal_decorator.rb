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
    investor_links = deal.investors.map { |i| h.decorate(i).link }.to_sentence

    string = "#{project_link} привлекли #{amount} #{round}"
    string << " от #{investor_links}" if investor_links.present?
    h.raw string
  end

  def meta
    scopes    = deal.project ? deal.project.scopes.includes(:parent) : []
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
