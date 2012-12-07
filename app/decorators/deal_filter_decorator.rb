# encoding: utf-8

class DealFilterDecorator < ApplicationDecorator
  def initialize(filter, options = {})
    super
    @view   = options[:view]
    @sorter = options[:sorter]
  end

  def round_select
    @view.render "filter/round-select", filter: self
  end

  def sector_select
    @view.render "filter/sector-select", filter: self
  end

  def sort_select
    options = { "Сумме" => "amount", "Дате" => "date" }

    links = options.map do |name, param|
      html_class = "active" if param.to_s == @sorter.current_column.to_s
      h.link_to name, params_with(sort: param), class: html_class
    end.join.html_safe

    tag :div, links, class: "horizontal-select sort"
  end

  def year_select(options = {})
    start_year = options[:from] || model.start_year
    years = start_year .. Time.current.year

    year_options = years.map { |year| [year.to_s, year.to_s] }
    year_options << ["Все", nil]

    links = year_options.map do |name, param|
      html_class = "active" if param.to_s == model.year.to_s
      h.link_to name, params_with(year: param), class: html_class
    end.join.html_safe

    tag :div, links, class: "horizontal-select year"
  end

  def params_with(options)
    @view.params.merge options.merge(page: nil)
  end
end
