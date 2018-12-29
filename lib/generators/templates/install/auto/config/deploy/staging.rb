server "#{fetch(:application)}.staging.molinos.ru", user: 'deployer', roles: %w(web app db), primary: true
set :deploy_user, :deployer
set :server_name, "#{fetch(:application)}.staging.molinos.ru"
set :app_name, fetch(:application)
set :user_home_dir, "/home/#{fetch(:deploy_user)}"
# set :god_port, PLACEHOLDER
set :keep_releases, 5
set :rails_env, 'staging'
set :unicorn_env, 'staging'
set :branch, :staging
set :unicorn_worker_processes, 1
set :deploy_to, "#{fetch(:user_home_dir)}/#{fetch(:application)}"
