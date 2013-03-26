# encoding: utf-8

class InvestorSorter < Sorter
  def sortable_columns
    {
      :investments  => :desc,
      :name         => :asc,
      :type         => :asc
    }
  end

  def sort(scope)
    case current_column
    when :name
      scope.order_by_name(current_direction)
    when :type
      scope.order_by_type(current_direction)
    when :investments
      scope.order_by_investments
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
