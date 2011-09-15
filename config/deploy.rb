# encoding: utf-8

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2@horovod'
set :rvm_type, :user

require 'rubygems'
require 'bundler/capistrano'

set :application, 'horovod'

role :web, ''
role :app, ''
role :db,  '', :primary => true

set :user, ''
set :use_sudo, false
set :rails_env, 'production'
set :rake, 'rake'

set :deploy_to, "/home/#{user}/projects/#{application}"
set :scm, :git
set :deploy_via, :remote_cache
set :repository, ''
set :branch, 'master'

set :bundle_gemfile, 'Gemfile'
set :bundle_dir, fetch(:shared_path) + '/bundle'
set :bundle_flags, '--deployment --quiet'
set :bundle_without, [ :development, :test ]
set :bundle_cmd, 'LANG=ru_RU.UTF-8 RACK_ENV=production bundle'

set :unicorn_rails, "#{bundle_cmd} exec unicorn_rails"
set :unicorn_conf, "/etc/unicorn/#{application}.dmitry-ustalov.rb"
set :unicorn_pid, "/var/run/unicorn/#{application}.dmitry-ustalov.pid"

after 'deploy:symlink' do
  release_log_dir = File.join(current_path, 'log')
  shared_log_dir = File.join(shared_path, 'log')
  run "rm -rf #{release_log_dir}"
  run "ln -sf #{shared_log_dir} #{release_log_dir}"

  sockets_dir = File.join(current_path, 'tmp', 'sockets')
  run("mkdir -p #{sockets_dir}")

  run("ln -sf #{shared_path}/things " +
      "#{current_path}/public/things")

  run("ln -sf #{shared_path}/database.yml " +
      "#{current_path}/config/database.yml")
end

namespace :deploy do
  task :start do
    run "cd #{current_path} && #{unicorn_rails} -Dc #{unicorn_conf} -E #{rails_env}"
  end
  task :stop do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}` || true"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && [ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_rails} -Dc #{unicorn_conf} -E #{rails_env}"
  end
end
