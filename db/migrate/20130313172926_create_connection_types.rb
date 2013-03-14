class CreateConnectionTypes < ActiveRecord::Migration
  def change
    create_table :connection_types do |t|
      t.string :source_class
      t.string :receiver_class
      t.string :direct_name
      t.string :reverse_name
      t.string :name
    end
  end
end
