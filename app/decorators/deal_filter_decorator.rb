# encoding: utf-8

class DealFilterDecorator < FilterDecorator
  def sort_select
    render_sort_select("Сумме" => "amount", "Дате" => "date")
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
end
