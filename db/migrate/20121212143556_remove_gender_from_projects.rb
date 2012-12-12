class RemoveGenderFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :gender
  end
end
