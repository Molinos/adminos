require 'pathname'
require 'dotenv'

# @see Dotenv::Railtie
module Adminos
  module Operations
    class LoadEnvironment
      def initialize(root: Pathname.pwd, env: ENV.fetch('RAILS_ENV', 'development'))
        @root = root
        @env = env
      end

      attr_reader :root
      attr_reader :env

      def call
        Dotenv.load(*dotenv_files)
      end

      def dotenv_files
        [
          root.join(".env.#{env}.local"),
          (root.join(".env.local") unless env == 'test'),
          root.join(".env.#{env}"),
          root.join(".env")
        ].compact
      end
    end
  end
end
