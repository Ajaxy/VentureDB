set_default(:sphinx_user) { user }
set_default(:sphinx_pid) { "#{shared_path}/pids/searchd.pid" }


before "deploy:update_code", "thinking_sphinx:stop"
after "deploy:create_symlink", "thinking_sphinx:configure"
after "deploy:create_symlink", "sphinx:reindex"
after "sphinx:reindex", "thinking_sphinx:start"

namespace :sphinx do
  desc "Symlink Sphinx indexes"
  task :symlink_indexes, roles: [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end

  desc "Regenerate indexes"
  task :reindex, roles: [:app] do
    run("cd #{deploy_to}/current && #{rake} ts:reindex RAILS_ENV=production")
  end
end
