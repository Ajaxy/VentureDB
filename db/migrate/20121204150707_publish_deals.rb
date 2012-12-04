class PublishDeals < ActiveRecord::Migration
  def up
    Deal.find_each { |deal| deal.publish }
  end

  def down
  end
end
