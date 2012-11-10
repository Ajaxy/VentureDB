# encoding: utf-8

class ProjectScope < ActiveRecord::Base
  belongs_to :project
  belongs_to :scope
end
