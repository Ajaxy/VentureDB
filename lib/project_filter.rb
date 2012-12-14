# encoding: utf-8

class ProjectFilter < Filter
  def filter(projects)
    projects = projects.search(search)  if search
    projects = projects.in_scope(scope) if scope
    projects = projects.in_round(round) if round
    projects
  end
end
