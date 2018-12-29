# frozen_string_literal: true

begin
  require 'bundler/audit/task'

  Bundler::Audit::Task.new
rescue LoadError => e
  namespace :bundle do
    task :audit do
      abort e.message unless Rails.env.development? || Rails.env.test?
    end
  end
end
