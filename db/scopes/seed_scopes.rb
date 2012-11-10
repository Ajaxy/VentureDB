# encoding: utf-8

roots = []
last_level = -1
last_scope = nil

Rails.root.join("db/scopes/scopes.txt").each_line do |line|
  line =~ /^(\t*)/
  level = $1.size

  name, short_name = line.strip.split("|")

  scope = Scope.create!(name: name, short_name: short_name)

  if level == last_level
    if roots.last
      # puts "#{scope.name} -> #{roots.last.name}"
      scope.move_to_child_of(roots.last)
    end
  elsif level > last_level
    roots << last_scope if last_scope
    if roots.last
      # puts "#{scope.name} -> #{roots.last.name}"
      scope.move_to_child_of(roots.last)
    end
  else
    roots.pop
  end

  last_level = level
  last_scope = scope
end
