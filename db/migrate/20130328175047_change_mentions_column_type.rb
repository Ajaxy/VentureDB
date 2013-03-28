class ChangeMentionsColumnType < ActiveRecord::Migration
  def up
    change_column :companies, :mentions, :text
    change_column :people, :mentions, :text
  end

  def down
    change_column :companies, :mentions, :string
    change_column :people, :mentions, :string
  end
end
