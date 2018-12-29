require 'adminos/generators/gemfile_merge'
require 'bundler'
require 'shellwords'

module Adminos
  module Generators
    module Utilities
      private

      def indent_code(code, with: '  ')
        code.split("\n").map { |line| line.present? ? "#{with}#{line}" : line }.join("\n")
      end

      def commit_changes(message)
        git add: '.'
        git commit: ['--message', message, '--author', 'Adminos Molinos <studio@molinos.ru>'].shelljoin
      end

      def run_in_root(command, with: nil, verbose: true, capture: nil, **options)
        Bundler.with_clean_env do
          ENV['DISABLE_SPRING'] = '1'
          command << options_for_cli(options)
          in_root { run(command, with: with, verbose: verbose, capture: capture) }
        end
      end

      def options_for_cli(options)
        options.inject('') do |command, (key, value)|
          case value
          when Array
            command << " --#{key}=#{value.join(' ')}"
          when TrueClass
            command << " --#{key}"
          when FalseClass
            command << " --no-#{key}"
          else
            command << " --#{key}=#{value.to_s.shellescape}"
          end
        end
      end

      def replace_file(file_name, contents)
        create_file(file_name, contents, force: true)
      end

      def merge_gemfile_with(source, target: Pathname.pwd.join('Gemfile'))
        gemfile = IO.read(target || 'Gemfile')
        addition = file_content(source)
        gemfile = GemfileMerge.new(addition, gemfile).merge
        replace_file target, gemfile if target
        gemfile
      end

      def binstubs(*gem_names, **options)
        run_in_root "bundle binstubs #{gem_names.shelljoin}", **options
      end

      #def generate(generator, *args, force: options.force?, quiet: options.quiet?)
      #  run_in_root "bin/rails generate #{generator} #{args.map(&Shellwords.method(:escape)).join(' ')}", force: force, quiet: quiet
      #end

      def file_content(file)
        IO.read(find_in_source_paths(file))
      end

      def file_exists?(file)
        File.exist?(file)
      end

      def rubocop_target_ruby_version
        RUBY_VERSION.split('.')[0..1].join('.')
      end

      def install_dependencies(verbose: !options.quiet?)
        run_in_root 'bundle install', verbose: verbose
        binstubs 'bundler', force: true, verbose: verbose
      end

      def migration_version
        major = ActiveRecord::VERSION::MAJOR
        if major >= 5
          "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
        end
      end
    end
  end
end
