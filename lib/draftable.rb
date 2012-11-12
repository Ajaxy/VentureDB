# encoding: utf-8

module Draftable
  extend ActiveSupport::Concern

  def publish
    update_column :draft, false
  end

  module ClassMethods
    def create_draft(attrs)
      create attrs.merge(draft: true)
    end

    def new_draft(attrs)
      new attrs.merge(draft: true)
    end

    def drafts
      where(draft: true)
    end

    def published
      where(draft: false)
    end
  end
end
