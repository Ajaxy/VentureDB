class CreatePeopleScopes < ActiveRecord::Migration
  def change
    create_table :people_scopes, id: false do |t|
      t.references :person
      t.references :scope
    end
  end
end
