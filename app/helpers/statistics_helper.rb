# encoding: utf-8

module StatisticsHelper
  def years_select
    periods      = []
    current_year = Time.now.year
    start_year   = current_year - 2
    end_year     = current_year - 1

    (start_year..end_year).each { |year| periods << [year, year] }
    periods << ["Все", nil]

    periods.inject('') do |result, period|
      result += date_select_button period.first, period.second, class: "js-reload-stats"
      result
    end.html_safe
  end
end
