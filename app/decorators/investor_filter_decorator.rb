# encoding: utf-8

class InvestorFilterDecorator < FilterDecorator
  def sort_select
    render_sort_select("Названию" => "name", "Инвестициям" => "investments")
  end
end
