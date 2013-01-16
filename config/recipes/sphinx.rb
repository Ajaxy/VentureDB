before 'deploy:update_code', 'thinking_sphinx:stop'
after 'deploy:update_code', 'sphinx:create_config'
after 'deploy:update_code', 'thinking_sphinx:start'

namespace :sphinx do
  desc "Symlink Sphinx indexes"
  task :symlink_indexes, roles: [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end

  desc "Create searchd config"
  task :create_config, roles: [:app] do
    run("cd #{deploy_to}/current && /usr/bin/env rake ts:config RAILS_ENV=production")
  end
end

after 'deploy:finalize_update', 'sphinx:symlink_indexes'
