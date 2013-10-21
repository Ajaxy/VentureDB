class ChangeSelectionFormat < ActiveRecord::Migration
  def self.up
    change_table :selections do |t|
      t.change :format_id, :text
      t.rename :format_id, :formats
    end
  end

  def self.down
    change_table :selections do |t|
      t.change :formats, :integer
      t.rename :formats, :format_id
    end
  end
end
