class RenamePersonPlanDuration < ActiveRecord::Migration
  def up
    rename_column :people, :plan_started_at, :plan_ends_at
  end

  def down
    rename_column :people, :plan_ends_at, :plan_started_at
  end
end
