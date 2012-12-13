class ChangeStages < ActiveRecord::Migration
  def up
    Deal.find_each do |deal|
      new_id = case deal.stage_id
        when 1, 2     then 1
        when 3        then 2
        when 4        then 3
        when 5, 6, 7  then 4
      end

      deal.update_column :stage_id, new_id
    end
  end

  def down
    raise "Can't rollback this migration"
  end
end
