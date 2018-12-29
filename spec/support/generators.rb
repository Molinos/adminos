module Rails
  module Generators
    module Testing
      module Behaviour
        def prepare_destination # :doc:
          # rm_rf(destination_root)
          # mkdir_p(destination_root)
        end
      end
    end
  end
end

module RSpec
  module Adminos
    module Specs
      module Generators
        module PrepareApp
          def system!(*args, quiet: !ENV['VERBOSE'])
            # https://github.com/bundler/bundler/issues/1424
            Bundler.with_clean_env do
              ENV['DISABLE_SPRING'] = '1'
              puts "Running: #{args.join(' ')}" unless quiet
              system(*args)
            end
          end

          def generate(command, quiet: !ENV['VERBOSE'])
            Dir.chdir(destination_root) do
              system! %(bin/rails generate #{command}), quiet: quiet
            end
          end
        end

        module Macros
          def generate(command, quiet: !ENV['VERBOSE'])
            Dir.chdir(destination_root) do
              system! %(bin/rails generate #{command}), quiet: quiet
            end
          end

          def system!(*args, quiet: !ENV['VERBOSE'])
            # https://github.com/bundler/bundler/issues/1424
            Bundler.with_clean_env do
              ENV['DISABLE_SPRING'] = '1'
              puts "Running: #{args.join(' ')}" unless quiet
              system(*args)
            end
          end

          def generate_rails(path, force: true, quiet: !ENV['VERBOSE'])
            path = Pathname(path)
            path.rmtree if force && path.exist?
            path.dirname.mkpath
            system!("rails new #{path} --no-rc -d postgresql#{' --quiet' if quiet}", quiet: quiet)
            Dir.chdir(path) do
              system! %(echo "gem 'adminos', path: '../../../adminos'" >> Gemfile), quiet: quiet
              system! "bundle install#{' --no-verbose' if quiet}", quiet: quiet
              yield if block_given?
            end
          end

          def generate_adminos(path, force: true, locales: false, quiet: !ENV['VERBOSE'])
            locales = locales.join(',') if locales.is_a?(Array)
            generate_rails(path, force: force, quiet: quiet) do
              generate %(adminos:install --is-test=true --force#{" --locales=#{locales}" if locales}#{' --quiet' if quiet}), quiet: quiet
            end
            path
          end

          def prepare_destination_first_time # :doc:
            FileUtils.rm_rf(destination_root)
            FileUtils.mkdir_p(destination_root)
          end

          def set_default_destination(folder_name)
            destination File.expand_path("../../../tmp/#{folder_name}", __FILE__)
          end

          def prepare_app(folder_name: folder_name, locales: false)
            set_default_destination(folder_name)
            prepare_destination_first_time
            generate_adminos(destination_root, quiet: true, locales: locales)
          end
        end

        def self.included(klass)
          super(klass)
          klass.extend(Macros)
          klass.include(PrepareApp)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Adminos::Specs::Generators, :type => :generator
end
