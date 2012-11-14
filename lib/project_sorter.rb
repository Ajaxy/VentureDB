# encoding: utf-8

class ProjectSorter < Sorter
  def sortable_columns
    {
      :name     => :asc,
      :company  => :asc,
    }
  end

  def sort(scope)
    case current_column
    when :name
      scope.order("name #{current_direction}")
    when :company
      scope.joins{company.outer}
           .order("companies.name #{current_direction} nulls last")
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
