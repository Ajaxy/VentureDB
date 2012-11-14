# encoding: utf-8

class DealSorter < Sorter
  def default_directions
    { id: :desc }
  end

  def sort(scope)
    case current_column
    when :project
      scope.joins{project.outer}.order("projects.name #{current_direction} nulls last")
    when :status
      scope.order("status_id #{current_direction}")
    when :amount
      scope.order("amount #{current_direction} nulls last")
    when :date
      scope.order("contract_date #{current_direction} nulls last")
    else
      scope.order("id #{current_direction}")
    end
  end
end
