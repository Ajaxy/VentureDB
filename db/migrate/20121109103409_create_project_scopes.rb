class CreateProjectScopes < ActiveRecord::Migration
  def change
    create_table :project_scopes do |t|
      t.references :project
      t.references :scope

      t.timestamps
    end
    add_index :project_scopes, :project_id
    add_index :project_scopes, :scope_id
  end
end
