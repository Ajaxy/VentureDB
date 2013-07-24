# encoding: utf-8

module ApplicationHelper
  def menu_link(name, url, options = {})
    html_class = "active" if url_for == url_for(url)
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

  def search_field(placeholder, options = {})
    entities_string = Array(options[:entities]).join(',')
    autosuggest     = !entities_string.empty?
    navigate        = options[:navigate] || false

    render partial: 'search', locals: { placeholder: placeholder, entities: entities_string,
      autosuggest: autosuggest, navigate: navigate }
  end

  def toggle_extended_search
    link_to 'Расширенный поиск', nil, id: 'toggle_extended_search'
  end

  def feedback_path
    "/about#feedback"
  end
end
