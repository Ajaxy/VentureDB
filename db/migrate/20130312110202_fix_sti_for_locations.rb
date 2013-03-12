class FixStiForLocations < ActiveRecord::Migration
  def up
    LocationBinding.find_each do |loc|
      case loc.entity_type
      when "Angel"
        loc.entity_type = "Person"
        loc.save!
      when "Investor"
        loc.entity_type = "Company"
        loc.save!
      end
    end
  end
  def down
    LocationBinding.find_each do |loc|
      case loc.entity_type
      when "Person"
        loc.entity_type = "Angel"
        loc.save!
      when "Company"
        loc.entity_type = "Investor"
        loc.save!
      end
    end
  end
end
