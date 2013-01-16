# encoding: utf-8

class DealSorter < Sorter
  def sortable_columns
    {
      :id       => :desc,
      :project  => :asc,
      :status   => :asc,
      :amount   => :desc,
      :date     => :desc,
    }
  end

  def sort(scope)
    case current_column
    when :id
      scope.order("id #{current_direction}")
    when :project
      scope.joins{project.outer}.order("projects.name #{current_direction} nulls last")
    when :status
      scope.order("status_id #{current_direction}")
    when :amount
      scope.order_by_amount(current_direction)
    when :date
      scope.order_by_started_at(current_direction)
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
