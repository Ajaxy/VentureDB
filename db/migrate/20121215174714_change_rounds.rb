class ChangeRounds < ActiveRecord::Migration
  def up
    Deal.find_each do |deal|
      id = deal.round_id

      id = 4 if id.in?(5, 6)
      id = 5 if id == 7

      deal.update_column :round_id, id if id != deal.round_id
    end
  end

  def down
    raise "Can't rollback this migration"
  end
end
