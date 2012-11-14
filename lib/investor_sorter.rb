# encoding: utf-8

class InvestorSorter < Sorter
  def default_column
    :name
  end

  def sort(scope)
    case current_column
    when :type
      scope.order("type_id #{current_direction}")
    else
      # NOTE: this will pull all existing records from the database
      scope = scope.sort_by(&:name)
      scope.reverse! if current_direction == :desc
      scope
    end
  end
end
