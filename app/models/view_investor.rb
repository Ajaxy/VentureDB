class ViewInvestor < ActiveRecord::Base
  has_many :investments, primary_key: 'uniq_id', foreign_key: 'uniq_investor_id'
  has_many :deals, through: :investments
  
  def self.order_by_full_name(direction)
    order("full_name #{direction}")
  end
end