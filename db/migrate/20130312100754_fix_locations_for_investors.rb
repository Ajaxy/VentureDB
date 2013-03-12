class FixLocationsForInvestors < ActiveRecord::Migration
  def change
    LocationBinding.find_each do |loc|
      if loc.entity_type == "Investor" and !loc.entity.nil?
        case loc.entity.actor_type
        when "Person"
          loc.entity_id = loc.entity.actor_id
          loc.entity_type = "Angel"
          loc.save!
        when "Company"
          loc.entity_id = loc.entity.actor_id
          loc.entity_type = "Investor"
          loc.save!
        end
      end
    end
  end
end
