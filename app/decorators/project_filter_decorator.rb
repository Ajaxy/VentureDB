# encoding: utf-8

class ProjectFilterDecorator < FilterDecorator
  def sort_select
    render_sort_select("Названию" => "name", "Инвестициям" => "investments")
  end
end
