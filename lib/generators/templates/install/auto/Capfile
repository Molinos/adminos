# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/scm/git'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/puma'
require 'capistrano-db-tasks'
require 'whenever/capistrano'
require 'capistrano/systemd/multiservice'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Nginx
install_plugin Capistrano::Systemd::MultiService.new_service('puma')
# install_plugin Capistrano::Systemd::MultiService.new_service('sidekiq')

lib_dir = File.join(__dir__, 'lib')
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
