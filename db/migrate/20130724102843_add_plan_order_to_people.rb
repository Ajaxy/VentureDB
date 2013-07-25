class AddPlanOrderToPeople < ActiveRecord::Migration
  def change
    add_column :people, :plan_order_plan, :integer
    add_column :people, :plan_order_months, :integer
    add_column :people, :plan_order_datetime, :datetime
  end
end
