# encoding: utf-8

class Selection < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :filter, :mailing

  def to_s; title || 'Без названия'; end
end
