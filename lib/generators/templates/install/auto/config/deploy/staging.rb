server "#{fetch(:application)}.staging.molinos.ru", user: 'app', roles: %w(web app db), primary: true

set :domain, "#{fetch(:application)}.staging.molinos.ru"
set :keep_releases, 5
set :rails_env, 'staging'
set :branch, :develop

set :user, :app
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# CentOS
set :nginx_sites_available_path, "#{fetch(:deploy_to)}/shared"
set :nginx_sites_enabled_path, '/etc/nginx/conf.d'

# Ubuntu
# set :nginx_sites_available_path, "/etc/nginx/sites-available"
# set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
