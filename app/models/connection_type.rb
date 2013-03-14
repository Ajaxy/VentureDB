class ConnectionType < ActiveRecord::Base
  attr_accessible :direct_name, :receiver_class, :reverse_name, :source_class, :name

  has_many :connections
end
