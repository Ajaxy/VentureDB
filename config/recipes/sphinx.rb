before "deploy:update_code", "thinking_sphinx:stop"
after "deploy:update_code", "thinking_sphinx:start"
after "deploy:update_code", "sphinx:reindex"

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

after "deploy:finalize_update", "sphinx:symlink_indexes"
