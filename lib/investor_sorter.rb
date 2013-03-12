# encoding: utf-8

class InvestorSorter < Sorter
  def sortable_columns
    {
      :full_name         => :asc,
      :type         => :asc,
      :investments  => :desc
    }
  end

  def sort(scope)
    case current_column
    when :full_name
      scope.order_by_full_name(current_direction)
    when :type
      scope.order_by_type(current_direction)
    when :investments
      scope.order_by_investments
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
