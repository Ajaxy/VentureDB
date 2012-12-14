# encoding: utf-8

class InvestorSorter < Sorter
  def sortable_columns
    {
      :name         => :asc,
      :type         => :asc,
      :investments  => :desc
    }
  end

  def sort(scope)
    case current_column
    when :name
      scope.order("name #{current_direction}")
    when :type
      scope.order("type_id #{current_direction}")
    when :investments
      scope.joins{investments.deal.inner}
           .select("investors.*, sum(deals.amount_usd) AS total_amount")
           .order("total_amount desc nulls last")
           .where{deals.published == true}
           .group{id}
    else
      raise ArgumentError.new("bad current_column #{current_column.inspect}")
    end
  end
end
