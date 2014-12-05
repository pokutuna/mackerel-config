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

namespace :deploy do

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
    end
  end
end
