require 'bundler/capistrano'
require 'capistrano_colors'
require 'thinking_sphinx/deploy/capistrano'

load 'config/recipes/base'
load 'config/recipes/nginx'
load 'config/recipes/unicorn'
load 'config/recipes/postgresql'
load 'config/recipes/misc'
load 'config/recipes/sphinx'

set :whenever_command, 'bundle exec whenever'
require 'whenever/capistrano'

set :default_environment, {
    'RBENV_ROOT' => '/root/.rbenv',
    'PATH' => "/root/.rbenv/shims:/root/.rbenv/bin:$PATH"
}
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

set :host, '176.58.109.103'
server host, :web, :app, :db, primary: true

desc 'Run tasks in staging enviroment.'
task :staging do
  set :application, 'venturedb.staging'
  set :branch, 'master'
  set :nginx_server_names, 'vd.ajaxy.ru'
end

desc 'Run tasks in production enviroment.'
task :production do
  set :application, 'venturedb'
  set :branch, 'stable'
  set :nginx_server_names, 'venturedatabase.ru vdprod.ajaxy.ru'
end

set :user, 'root'
set :deploy_to, -> { "/home/ajaxy/www/#{application}" }
#set :deploy_via, :remote_cache
set :use_sudo, false
default_run_options[:pty] = true

set :scm, 'git'
set :scm_user, 'Ajaxy'
set :repository, 'git@github.com:Ajaxy/VentureDB.git'

set :postgresql_password, '111'

ssh_options[:forward_agent] = true