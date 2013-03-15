module Admin
  module ConnectionsHelper
    def connection_options(entity)
      connection_types = entity.connection_types
      options = connection_types.map do |type|
        name = entity.class.to_s == type.source_class ? type.direct_name : type.reverse_name
        klass = entity.class.to_s == type.source_class ? type.receiver_class : type.source_class
        [name, type.id, { 'data-receiver-class' => klass }]
      end
      options_for_select(options)
    end

    def display_connection(connection)
      connection_type = connection.connection_type
      text = connection.from_type == connection_type.source_class ? connection_type.direct_name : connection_type.reverse_name
      "#{text} <strong>#{connection.to.name}</strong>".html_safe
    end
  end
end
