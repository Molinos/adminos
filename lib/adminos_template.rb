require 'adminos/generators/utilities'

extend Adminos::Generators::Utilities

commit_changes 'Generate Rails application'

gem 'adminos', source: 'https://gems.molinos.ru/'
run 'bundle install'
generate 'adminos:install'

commit_changes 'Set up Adminos'

after_bundle do
  commit_changes 'Finish rails app setup'
end
