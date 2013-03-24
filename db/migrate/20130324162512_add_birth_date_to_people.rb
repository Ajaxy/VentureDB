class AddBirthDateToPeople < ActiveRecord::Migration
  def change
    add_column :people, :birth_date, :string
  end
end
