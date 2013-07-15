class AddPlansToPeople < ActiveRecord::Migration
  def change
    add_column :people, :plan, :integer, default: 1
    add_column :people, :plan_started_at, :datetime
    add_column :people, :used_connections, :integer
    add_column :people, :used_profiles_access, :integer
    add_column :people, :used_downloads, :integer
    add_column :people, :used_support_mins, :integer
  end
end