class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.belongs_to :user
      t.string :title
      t.text :filter
      t.boolean :mailing

      t.timestamps
    end
    add_index :selections, :user_id
  end
end
