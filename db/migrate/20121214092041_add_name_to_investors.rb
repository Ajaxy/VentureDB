class AddNameToInvestors < ActiveRecord::Migration
  def change
    add_column :investors, :name, :string
    add_index :investors, :name

    Investor.find_each { |inv| inv.actor.try(:save) }
  end
end
