class AddAssociationToInvestorInvestment < ActiveRecord::Migration
  def change
    add_column :investments, :uniq_investor_id, :string

    Investment.find_each do |i|
      case i.investor_entity_type
      when "Person"
        i.uniq_investor_id = "Angel_#{i.investor_entity_id}"
        i.save!
      when "Company"
        i.uniq_investor_id = "Investor_#{i.investor_entity_id}"
        i.save!
      end
    end
  end
end
