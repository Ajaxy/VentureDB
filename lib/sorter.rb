# encoding: utf-8

class Sorter
  attr_reader :params
  attr_reader :view

  def initialize(params, view)
    @params = params
    @view   = view
  end

  def default_column
    :id
  end

  def default_directions
    {}
  end

  def header(name, column, html_options = {})
    link_params = params.merge(sort: column, direction: direction_for(column))
    link_params.delete(:page)

    link = view.link_to name, link_params, html_options

    if column == current_column
      icon_name = current_direction == :desc ? "up" : "down"
      icon = view.content_tag(:i, "", class: "icon-chevron-#{icon_name}")
      link + icon
    else
      link
    end
  end

  private

  def current_column
    params[:sort].try(:to_sym) || default_column
  end

  def current_direction
    param = params[:direction].try(:to_sym)
    param.in?(:asc, :desc) ? param : default_directions[current_column]
  end

  def default_direction(column)
    default_directions[column] || :asc
  end

  def direction_for(column)
    current_column == column ? invert(current_direction) : default_direction(column)
  end

  def invert(direction)
    direction == :asc ? :desc : :asc
  end
end
