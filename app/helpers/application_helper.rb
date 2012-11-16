# encoding: utf-8

module ApplicationHelper
  def menu_link(name, url, options = {})
    html_class = "active" if url.to_s == controller_name.to_s
    link = link_to name, url, options
    content_tag :li, link, class: html_class
  end

  def cabinet_menu_link(name, section)
    html_class = "active" if section.to_s == action_name
    link = link_to name, section
    content_tag :li, link, class: html_class
  end
end
