# encoding: utf-8

class Selection < ActiveRecord::Base
  belongs_to :user
  serialize :formats

  def to_s; !title.empty? ? title : 'Без названия' end

  def filter
    filter = attributes
      .slice(*%w[formats amount_from amount_to year quarter amount_without_empty amount_without_approx])
      .delete_if { |k, v| v.nil? }
    { extended_search: filter }
  end
end
