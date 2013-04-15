# encoding: utf-8

class ConnectionDecorator < ApplicationDecorator
  decorates :connection

  def direct_name
    connection_type.direct_name
  end

  def reverse_name
    connection_type.reverse_name
  end

  def from_name
    from.name
  end

  def to_name
    to.name
  end
end

