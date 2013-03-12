class ConnectionBinding < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :connect_from, polymorphic: true
  belongs_to :connect_to, polymorphic: true
end
