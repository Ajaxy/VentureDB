module Connectable
  extend ActiveSupport::Concern

  included do
    has_many :from_connections, class_name: 'Connection', as: :from
    has_many :to_connections, class_name: 'Connection', as: :to

    accepts_nested_attributes_for :from_connections, allow_destroy: true
  end

  def connection_types
    self.class.connection_types
  end

  module ClassMethods
    def connection_types
      [
        ConnectionType.where(source_class: [self.to_s, 'all']) +
        ConnectionType.where(receiver_class: [self.to_s, 'all'])
      ].flatten.uniq
    end
  end
end
