# config valid only for current version of Capistrano
lock '3.3.3'

set :application, 'mackerel-config'
set :repo_url, 'git@github.com:pokutuna/mackerel-config.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :deploy_to, '/home/deploy/apps/mackerel-config'

set :log_level, :info

set :config_file,        'mackerel-agent.conf'
set :remote_config_path, '/etc/mackerel-agent/mackerel-agent.conf'

set :script_dir,         'scripts'
set :remote_script_dir,  '/etc/mackerel-agent/scripts'

desc 'Report mackerel-agent process status'
task :ps do
  on roles(:server) do
    info "Host #{host}:\n#{capture('ps -eo pid,comm,lstart,etime,time | grep mackerel-agent')}"
  end
end


namespace :deploy do
  after :starting, :ps
  after :publishing, :restart

  task :restart do
    on roles(:server) do
      execute :sudo, 'service mackerel-agent restart'
    end
  end
end

namespace :setup do
  task :symlink do
    on roles(:server) do
      execute :sudo, "ln -fs #{release_path.join(fetch(:config_file))} #{fetch(:remote_config_path)}"
      execute :sudo, "ln -fs #{release_path.join(fetch(:script_dir))} #{fetch(:remote_script_dir)}"
    end
  end
end
