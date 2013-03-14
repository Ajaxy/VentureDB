module Admin
  module ConnectionsHelper
    def connection_options(entity)
      connection_types = entity.connection_types
      options          = connection_types.map do |type|
        [type.direct_name, type.id, { 'data-receiver-class' => type.receiver_class }]
      end
      options_for_select(options)
    end
  end
end
