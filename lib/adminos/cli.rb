require 'thor'
require 'thor/actions'
require 'bundler'
require 'pathname'
require_relative 'operations/extract_environment'
require_relative 'operations/check_environment'
require_relative 'operations/load_environment'

module Adminos
  class CLI < Thor
    include Thor::Actions

    desc 'new NAME', 'Creates new Rails application enhanced with Adminos'
    def new(name)
      Bundler.with_clean_env do
        run "rails new #{name} --template #{Pathname(__dir__).join('../adminos_template.rb')}"
      end
    end

    desc 'env', 'Checks environment variables'
    def env
      load_environment.()
      missing = check_environment.()
      # TODO: Use variables mapping from extract_environment

      unless missing.any?
        puts "No variables missing"
        return
      end

      puts "Missing environment variables:"
      missing.map do |name|
        puts "* #{name}: #{ENV[name]}"
      end

      abort "Please fill in variables according to suggestions above"
    end

    desc 'extract_env', 'Checks ruby code for ENV vars used'
    def extract_env
      puts "Checking for possibly missed environment variables..."

      local_env = Pathname('.env.local')

      extract_environment.().inject([]) do |result, (variable, usage)|
        next result if ENV.key?(variable)

        puts "#{variable}:"
        usage.each do |location|
          puts " * #{location.values.join(':')}"
        end

        local_env.open('a') { |f| f.puts "# #{variable}='' # #{usage.first.values.join(':')}" }
      end
    end

    private

    def check_environment
      @check_environment ||= Operations::CheckEnvironment.new
    end

    def extract_environment
      @extract_environment ||= Operations::ExtractEnvironment.new
    end

    def load_environment
      @load_environment ||= Operations::LoadEnvironment.new
    end
  end
end
