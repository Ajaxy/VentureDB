# encoding: utf-8

class Scope < ActiveRecord::Base
  acts_as_nested_set

  def deals
    @deals ||= begin
      lft = self[:lft]
      rgt = self[:rgt]
      Deal.joins{project.scopes}
          .where{(project.scopes.lft >= lft) & (project.scopes.lft < rgt)}.to_a
    end
  end

  def short_name
    self[:short_name] || name
  end

  def amount
    deals.sum { |deal| deal.amount || 0 }
  end

  def count
    deals.length
  end
end

