# encoding: utf-8

class ProjectFilter < Filter
  def filter(projects)
    projects = projects.search(search)  if search
    projects = projects.in_scope(scope) if scope
    projects
  end
end
