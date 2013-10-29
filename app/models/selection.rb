# encoding: utf-8

class Selection < ActiveRecord::Base
  belongs_to :user
  serialize :formats

  validate :_prevent_all_empty

  def to_s; !title.empty? ? title : 'Без названия' end

  def filter
    filter = attributes
      .slice(*%w[formats amount_from amount_to year quarter amount_without_empty amount_without_approx])
      .delete_if { |k, v| v.nil? || !v.present? }
    { extended_search: filter }
  end

  private

  def _prevent_all_empty
    if attributes.slice(*%w[amount_from amount_to year quarter formats amount_without_empty amount_without_approx])
      .all? { |k, p| p.kind_of?(Array) ? (p - %w[0]).empty? : p.blank? || p.to_i == 0 }
        errors[:base] << 'Укажите критерии выборки'
    end
  end
end
