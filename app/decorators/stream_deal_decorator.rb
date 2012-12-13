# encoding: utf-8

class StreamDealDecorator < DealDecorator
  decorates :deal

  def amount
    if deal.amount?
      tag :b, millions(deal.amount)
    else
      ". Сумма сделки не разглашается."
    end
  end
  
  def grant_amount
    if deal.amount?
      "в размере " + tag(:b, millions(deal.amount))
    else
      ". Сумма гранта не разглашается."
    end
  end
  
  def verb
    if deal.is_grant
      verb = deal.investors.size == 1 ? "выдал грант" : "выдали грант"
    else
      verb = deal.investors.size == 1 ? "инвестировал" : "инвестировали"
    end
  end

  def date
    return unless deal.date
    h.localize deal.date, format: "%e %B %Y"
  end

  def description
    if deal.is_grant
      h.raw "#{investor_links} #{verb} проекту #{project_link} #{grant_amount}"
    else
      h.raw "#{investor_links} #{verb} в #{project_link} #{amount}"
    end
  end

  def investor_links
    return "Неизвестные инвесторы" if deal.investors.empty?
    deal.investors.map { |i| h.decorate(i).link }.to_sentence
  end

  def meta
    deal.project && deal.project.scopes.any? ? deal.project.scopes.first().full_name : ""
  end

  def project_link
    return "—" unless deal.project
    h.link_to project_name, deal.project
  end
end
