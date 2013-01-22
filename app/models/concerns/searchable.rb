module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search(query = nil)
      unless query.blank?
        ids = search_for_ids(query)
        where(id: ids)
      else
        scoped
      end
    end
  end
end
