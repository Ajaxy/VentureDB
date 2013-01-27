module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    if Rails.env.development?
      def search(query = nil); scoped; end
    else
      def search(query = nil)
        unless query.blank?
          ids = search_for_ids(query, star: true)
          where(id: ids)
        else
          scoped
        end
      end
    end
  end
end
