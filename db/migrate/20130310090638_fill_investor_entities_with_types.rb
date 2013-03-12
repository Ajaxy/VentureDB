class FillInvestorEntitiesWithTypes < ActiveRecord::Migration
  def change
    add_column :people, :type_id, :integer
    
    remove_index :investors, :name
    remove_index :investors, :type_id
    remove_index :investors, [:actor_id, :actor_type]

    Investor.find_each do |inv|
      case inv.actor_type
      when "Person"
        i = Person.find_by_id(inv.actor_id)
        if i
          i.type_id = inv.type_id || 0
          i.type = "Angel"
          i.save!
        end
      when "Company"
        i = Company.find_by_id(inv.actor_id)
        if i
          i.type_id = inv.type_id || 0
          i.type = "Investor"
          i.save!
        end
      end
    end
  end
end
