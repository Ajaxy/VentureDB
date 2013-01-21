# encoding: utf-8

class ProjectSorter < Sorter
  def sortable_columns
    {
      :name         => :asc,
      :company      => :asc,
      :investments  => :desc,
    }
  end

  def sort(scope)
    case current_column
    when :name
      scope.order_by_name(current_direction)
    when :company
      scope.joins{company.outer}
           .order("companies.name #{current_direction} nulls last")
    when :investments
      scope.order_by_investments
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
