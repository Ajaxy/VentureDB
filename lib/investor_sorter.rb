# encoding: utf-8

class InvestorSorter < Sorter
  def sortable_columns
    {
      :name  => :asc,
      :type  => :asc,
    }
  end

  def sort(scope)
    case current_column
    when :name
      # NOTE: this will pull all existing records from the database
      scope = scope.sort_by(&:name)
      scope.reverse! if current_direction == :desc
      scope
    when :type
      scope.order("type_id #{current_direction}")
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
