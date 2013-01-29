# encoding: utf-8

class CompanySorter < Sorter
  def sortable_columns
    {
      :name  => :asc,
      :place => :asc
    }
  end

  def sort(scope)
    case current_column
    when :name
      scope.order_by_name(current_direction)
    when :place
      scope.order_by_place(current_direction)
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
