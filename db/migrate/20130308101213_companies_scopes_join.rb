class CompaniesScopesJoin < ActiveRecord::Migration
  def change
    create_table :companies_scopes, id: false do |t|
      t.references :company
      t.references :scope
    end
  end
end
