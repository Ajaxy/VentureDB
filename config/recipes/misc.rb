namespace :check do
  desc "Make sure local git is in sync with remote."
  task :revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "check:revision"
  before "deploy:migrations", "check:revision"
  before "deploy:cold", "check:revision"
end

namespace :downloads do
  desc "Symlink the downloads directory into latest release"
  task :symlink, roles: :app do
    run "mkdir -p #{shared_path}/downloads"
    run "ln -nfs #{shared_path}/downloads #{release_path}/public/"
  end
  after "deploy:finalize_update", "downloads:symlink"
end

# Only precompile assets if any assets files actually changed since last release
namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      begin
        from = source.next_revision(current_revision)
        if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ lib/assets/ | wc -l").to_i > 0
          precompile_all
        else
          logger.info "Skipping asset pre-compilation because there were no asset changes"
        end
      rescue
        precompile_all
      end
    end

    task :precompile_all, :roles => assets_role, :except => { :no_release => true } do
      run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
    end
  end
end
