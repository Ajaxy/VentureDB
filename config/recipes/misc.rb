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
