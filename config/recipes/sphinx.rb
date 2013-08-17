set_default(:sphinx_user) { user }
set_default(:sphinx_pid) { "#{shared_path}/pids/searchd.pid" }


before "deploy:update_code", "thinking_sphinx:stop"
after "deploy:update_code", "thinking_sphinx:start"
#after "deploy:update_code", "sphinx:reindex"

namespace :sphinx do
  desc "Setup Sphinx initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "sphinx_init.erb", "/tmp/sphinx_init"
    run "chmod +x /tmp/sphinx_init"
    run "#{sudo} mv /tmp/sphinx_init /etc/init.d/sphinx_#{application}"
    run "#{sudo} update-rc.d -f sphinx_#{application} defaults"
  end
  after "deploy:setup", "sphinx:setup"

  desc "Symlink Sphinx indexes"
  task :symlink_indexes, roles: [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end

  desc "Regenerate indexes"
  task :reindex, roles: [:app] do
    run("cd #{deploy_to}/current && #{rake} ts:reindex RAILS_ENV=production")
  end
end

#after "deploy:finalize_update", "sphinx:symlink_indexes"
