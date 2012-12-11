# encoding: utf-8

module ApplicationHelper
  def menu_link(name, url, options = {})
    html_class = "active" if url.to_s == controller_name.to_s
    link = link_to name, url, options
    content_tag :li, link, class: html_class
  end

  def date_select_button(text, param)
    html_class = "active" if param == params[:year].to_s
    link = link_to text, params.merge(year: param), class: html_class
  end

  def b(*args, &block)
    content_tag :strong, *args, &block
  end
end
