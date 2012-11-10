class CreateProjectAuthors < ActiveRecord::Migration
  def change
    create_table :project_authors do |t|
      t.references :project
      t.references :author

      t.timestamps
    end
    add_index :project_authors, :project_id
    add_index :project_authors, :author_id
  end
end
