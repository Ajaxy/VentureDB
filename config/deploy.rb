require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano_colors"
require "thinking_sphinx/deploy/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/misc"
load "config/recipes/sphinx"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :host, "176.58.108.251"
server host, :web, :app, :db, primary: true

set :application, "venture.staging"
set :branch, "master"
set :nginx_server_names, "venture.stage.grow.bi venturedatabase.ru " +
                         "www.venturedatabase.ru"

set :user, "root"
set :deploy_to, -> { "/srv/#{application}" }
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:AndreyM/VentureDB.git"

set :rvm_type, :system
set :postgresql_password, "111"

ssh_options[:forward_agent] = true
