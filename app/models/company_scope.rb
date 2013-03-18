class CompanyScope < ActiveRecord::Base
  attr_accessible :company_id, :scope_id

  belongs_to :company
  belongs_to :scope
end
