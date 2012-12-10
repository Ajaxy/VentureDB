class AddGenderToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :gender, :boolean, default: true
  end
end
