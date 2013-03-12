class AddFieldsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :age, :integer
    add_column :people, :sex, :string
  end
end
