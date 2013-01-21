# encoding: utf-8

class DealFilterDecorator < FilterDecorator
  def type_select
    @view.render "filter/deal-type-select", filter: self
  end

  def sort_select
    render_sort_select("Сумме" => "amount", "Дате" => "date")
  end

  def year_select(options = {})
    current_year = Time.current.year
    start_year = options[:from] || current_year - 2
    years = start_year .. (current_year - 1)

    year_options = years.map { |year| [year.to_s, year.to_s] }
    year_options << ["Все", nil]

    links = year_options.map do |name, param|
      html_class = "active" if param.to_s == model.year.to_s
      h.link_to name, params_with(year: param), class: html_class
    end.join.html_safe

    tag :div, links, class: "horizontal-select year"
  end
end
