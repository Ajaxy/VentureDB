class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.references :investor
      t.references :deal
      t.references :instrument
      t.text :share

      t.timestamps
    end
    add_index :investments, :investor_id
    add_index :investments, :deal_id
    add_index :investments, :instrument_id
  end
end
