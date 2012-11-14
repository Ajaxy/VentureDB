# encoding: utf-8

class InvestorSorter < Sorter
  set_default_column :name

  def sort(scope)
    case current_column
    when :type
      scope.order("type_id #{current_direction}")
    else
      scope = scope.sort_by(&:name)
      scope.reverse! if current_direction == :desc
      scope
    end
  end
end
