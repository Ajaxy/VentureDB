class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.references :project
      t.boolean :approx_date, default: false
      t.date :announcement_date
      t.date :contract_date
      t.references :status
      t.references :round
      t.references :stage
      t.boolean :approx_amount, default: false
      t.integer :amount, limit: 8
      t.integer :value_before, limit: 8
      t.integer :value_after, limit: 8
      t.references :informer
      t.string :financial_advisor
      t.string :legal_advisor
      t.text :mentions
      t.text :comments
      t.text :errors_log

      t.timestamps
    end
    add_index :deals, :project_id
    add_index :deals, :status_id
    add_index :deals, :round_id
    add_index :deals, :stage_id
    add_index :deals, :informer_id
  end
end
