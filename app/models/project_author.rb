# encoding: utf-8

class ProjectAuthor < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "Person"
end
