module Connectable
  extend ActiveSupport::Concern

  included do
    has_many :from_connections, class_name: 'Connection', as: :from, dependent: :destroy
    has_many :to_connections, class_name: 'Connection', as: :to, dependent: :destroy

    accepts_nested_attributes_for :from_connections, allow_destroy: true
  end

  def connection_types
    self.class.connection_types
  end

  module ClassMethods
    def connection_types
      [
        ConnectionType.where(source_class: [self.to_s, ConnectionType::TYPE_ALL]) +
        ConnectionType.where(receiver_class: [self.to_s, ConnectionType::TYPE_ALL])
      ].flatten.uniq
    end
  end
end
