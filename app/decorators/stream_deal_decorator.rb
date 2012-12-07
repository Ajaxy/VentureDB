# encoding: utf-8

class StreamDealDecorator < DealDecorator
  decorates :deal

  def amount
    if deal.amount?
      millions(deal.amount)
    else
      "неизвестную сумму"
    end
  end

  def date
    return unless deal.date
    h.localize deal.date, format: "%e %B %Y"
  end

  def description
    investor_links = deal.investors.map do |investor|
      h.link_to investor.name, "#"
    end.to_sentence

    h.raw "#{project_link} привлекли #{amount} #{round} от #{investor_links}"
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
