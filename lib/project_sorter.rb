# encoding: utf-8

class ProjectSorter < Sorter
  def default_column
    :name
  end

  def sort(scope)
    case current_column
    when :company
      scope.joins{company.outer}
           .order("companies.name #{current_direction} nulls last")
    else
      scope.order("name #{current_direction}")
    end
  end
end
