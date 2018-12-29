require 'adminos/generators/utilities'
require 'rails/generators/base'

module Adminos::Generators
  class CiGenerator < Rails::Generators::Base
    include Utilities

    desc 'Set up CI'

    source_root File.expand_path '../../templates/ci', __FILE__

    # ActiveRecord::Generators::Base requires a NAME parameter.
    argument :name, type: :string, default: 'random_name'

    # options
    class_option :gitlab, type: :boolean, default: true, desc: 'Set up Gitlab CI'

    TEST_STEPS = {
      audit: {
        desc: 'Audit dependencies using bundler-audit',
        gemfile: true,
        binstubs: %w[bundler-audit],
        rakelib: true,
        ci_job: <<~YAML
          script: bin/rake bundle:audit
        YAML
      },
      spec: {
        desc: 'Specify application with RSpec',
        gemfile: true,
        binstubs: %w[rspec-core],
        ci_job: <<~YAML
          script: bin/rake spec
          artifacts:
            paths:
              - coverage/
              - spec/examples.txt
        YAML
      },
      lint: {
        desc: 'Lint dependencies with RuboCop',
        gemfile: true,
        rakelib: true,
        binstubs: %w[rubocop],
        ci_job: <<~YAML
          script: bin/rubocop
          allow_failure: true
        YAML
      }
    }

    TEST_STEPS.each do |name, default: true, desc:, **|
      class_option name, type: :boolean, default: default, desc: desc
    end

    def bundle_dependencies
      gems = []
      TEST_STEPS.each do |name, gemfile: false, binstubs: [], **|
        next unless options[name]

        merge_gemfile_with("#{name}/Gemfile") if gemfile
        gems += binstubs
      end
      install_dependencies
      binstubs(*gems)
    end

    def setup_rakelib
      TEST_STEPS.each do |name, rakelib: false, **|
        next unless options[name] && rakelib

        copy_file "rakelib/#{name}.rake"
      end
    end

    def setup_gitlab
      return unless options.gitlab?

      template '.gitlab-ci.yml'
      TEST_STEPS.each do |name, ci_job: true, **|
        next unless options[name] && ci_job

        ci_job name, ci_job
      end
    end

    def setup_rspec
      return unless options.spec?

      # Generate standard RSpec configuration
      generate 'rspec:install'

      # Uncomment good defaults
      gsub_file 'spec/spec_helper.rb', /\n=begin\n/, "\n"
      gsub_file 'spec/spec_helper.rb', /\n=end\n/, "\n"

      # Inject Adminos helpers
      inject_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do
        indent_code(<<~RUBY) << "\n"
          config.include FactoryBot::Syntax::Methods
          config.include ActionDispatch::TestProcess

          config.before :suite do
            DatabaseCleaner.strategy = :truncation
          end
        RUBY
      end
    end

    def setup_rubocop
      return unless options.lint?

      template 'lint/rubocop.yml', '.rubocop.yml'
      run_in_root 'bin/rubocop --auto-gen-config &>/dev/null'
    end

    private

    def ci_job(name, contents)
      job = "#{name}:\n#{contents.gsub(/^/, '  ')}"
      append_file '.gitlab-ci.yml', job
    end
  end
end
