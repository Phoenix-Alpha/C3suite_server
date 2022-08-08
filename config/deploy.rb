set :repo_url, 'git@github.com:Code3Apps/C3suite_server.git'
set :application, 'C3suite_server'
set :user, 'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

set :linked_files, fetch(:linked_files, []).push('config/application.yml', 'config/database.yml', 'config/secrets.yml', 'config/.env.production')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'node_modules')

# Delayed job
# set :delayed_job_workers, 5

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end


namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc "Seeding Database with necassary data"
  task :seed do
    on primary :db do
      within current_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  desc "symlinks web and app server configuration"
  task :setup_config do
    on roles(:app, :web) do |host|
      execute "sudo ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
    end
  end

  desc 'check for config files in place on server'
  task :check_symlinks do
    on roles(:app, :web) do
      unless test("[ -f /etc/nginx/sites-enabled/#{fetch(:application)} ]")
        invoke "deploy:setup_config"
      end
    end
  end

  before :check, :setup_config

  before :starting,     :check_revision
  after :starting,      :check_symlinks

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

namespace :rails do
  desc 'Open a rails console `cap [staging] rails:console [server_index default: 0]`'
  task :console do
    server = roles(:app)[ARGV[2].to_i]
    puts "Opening a console on: #{server.hostname}…."
    cmd = "ssh #{server.user}@#{server.hostname} -t 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} bundle exec rails console'"
    puts cmd
    exec cmd
  end

  desc 'Open ssh `cap [staging] ssh [server_index default: 0]`'
  task :ssh do
    server = roles(:app)[ARGV[2].to_i]
    puts "Opening a console on: #{server.hostname}…."
    cmd = "ssh #{server.user}@#{server.hostname}"
    puts cmd
    exec cmd
  end
end
