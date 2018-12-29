require 'pathname'

# @see Dotenv::Railtie
module Adminos
  module Operations
    class CheckEnvironment
      EXPRESSION = /`(\.env.*)`/

      def call
        ENV.inject([]) do |result, (name, value)|
          next result unless value =~ EXPRESSION

          result << name
        end
      end
    end
  end
end
