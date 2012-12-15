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
      scope.order("projects.name #{current_direction}")
    when :company
      scope.joins{company.outer}
           .order("companies.name #{current_direction} nulls last")
    when :investments
      scope.joins{deals.outer}
           .select("projects.*, sum(deals.amount_usd) AS total_amount")
           .order("total_amount desc nulls last")
           .group{id}
           .where{deals.published == true}
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
