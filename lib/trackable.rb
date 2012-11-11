# encoding: utf-8

module Trackable
  extend ActiveSupport::Concern

  included do
    has_one :creator, class_name: "User"
    has_one :updater, class_name: "User"
  end

  module ClassMethods
    def create_tracking_user(user, params, &block)
      create(params.merge(creator: user), &block)
    end
  end

  def update_tracking_user(user, params, &block)
    update_attributes(params.merge(updater: user), &block)
  end
end
