# frozen_string_literal: true

begin
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new

  task lint: :rubocop
rescue LoadError => e
  task :lint do
    abort e.message unless Rails.env.development? || Rails.env.test?
  end
end
