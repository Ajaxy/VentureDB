class AddIndexToCompanyIdInDeals < ActiveRecord::Migration
  def change
    add_index :deals, :company_id
  end
end
