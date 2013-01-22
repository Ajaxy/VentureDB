# encoding: utf-8

class FilterDecorator < ApplicationDecorator
  def initialize(filter, options = {})
    @view   = options.delete(:view)
    @sorter = options.delete(:sorter)
    super
  end

  def round_select
    @view.render "filter/round-select", filter: self
  end

  def stage_select
    @view.render "filter/stage-select", filter: self
  end

  def sector_select
    @view.render "filter/sector-select", filter: self
  end

  def params_with(options)
    @view.params.merge options.merge(page: nil)
  end

  private

  def render_sort_select(options)
    links = options.map do |name, param|
      html_class = "active" if param.to_s == @sorter.current_column.to_s
      h.link_to name, params_with(sort: param), class: html_class
    end.join.html_safe

    tag :div, links, class: "horizontal-select sort"
  end
end
