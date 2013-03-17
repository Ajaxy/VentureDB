class AddCompanyIdToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :company_id, :integer
  end
end
