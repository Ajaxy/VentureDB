class ChangeSelectionFormat < ActiveRecord::Migration
  def change
    change_table :selections do |t|
      t.change :format_id, :text
      t.rename :format_id, :formats
    end
  end
end
