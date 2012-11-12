# encoding: utf-8

class ProjectDecorator < ApplicationDecorator
  decorates :project

  def scope_names
    return "—" unless scopes.any?
    list scopes.map(&:name)
  end

  def author_names
    return "—" unless authors.any?
    list authors.map(&:full_name)
  end
end
