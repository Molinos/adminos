require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/generators/*_test.rb'
  t.verbose = true
  t.warning = false
end
task default: :test

RSpec::Core::RakeTask.new(:spec)
task defualt: :spec

RuboCop::RakeTask.new
task lint: :rubocop

task default: :lint
