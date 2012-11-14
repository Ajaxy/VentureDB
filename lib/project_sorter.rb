# encoding: utf-8

class ProjectSorter < Sorter
  set_default_column :name

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
