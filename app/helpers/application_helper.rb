# encoding: utf-8

module ApplicationHelper
  def menu_link(name, url, options = {})
    html_class = "active" if url.to_s == controller_name.to_s
    link = link_to name, url, options
    content_tag :li, link, class: html_class
  end

  def date_select_button(text, param, options = {})
    html_class = options.delete(:class)

    if param.to_s == params[:year].to_s
      html_class = [html_class, "active"].compact.join(" ")
    end

    link = link_to text, params.merge(year: param), class: html_class
  end

  def b(*args, &block)
    content_tag :strong, *args, &block
  end

  def search_field(placeholder, entites = '')
    entites_string = Array(entites).join(',')
    autosuggest    = !entites_string.empty?

    render partial: 'search', locals: { placeholder: placeholder, entites: entites_string,
      autosuggest: autosuggest }
  end
end
