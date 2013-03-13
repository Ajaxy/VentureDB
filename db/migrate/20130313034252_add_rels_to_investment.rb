class AddRelsToInvestment < ActiveRecord::Migration
  def up
    add_column :investments, :actor_type, :string
    add_column :investments, :actor_id, :integer

    Investment.all.each do |i|
      i.actor_type = i.investor.actor_type
      i.actor_id = i.investor.actor_id
    end
  end

  def down
    remove_column :investments, :actor_type
    remove_column :investments, :actor_id
  end
end
