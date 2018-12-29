require 'pathname'

module Adminos
  module Operations
    class ExtractEnvironment
      OPTIONAL = %w[RAILS_ENV VERBOSE DISABLE_SPRING PORT WEB_CONCURRENCY]

      def extensions
        %w[ru thor rake rb yml ruby yaml erb builder markerb slim haml cap]
      end

      # @return [{String => <{path: Pathname, line: Integer}>}]
      def call(globs = '*')
        results = Hash.new { |hash, key| hash[key] = [] }

        Array(globs).each do |glob|
          Pathname.glob(glob).each do |item|
            next results.merge!(call(item.join('*'))) if item.directory?

            next unless extensions.detect { |ext| item.extname.to_s[ext] }

            item.readlines.each_with_index do |line, ix|
              capture_variables(line).each do |variable|
                next if OPTIONAL.include?(variable)

                results[variable] << { path: item, line: ix.succ }
              end
            end
          end
        end

        Hash[results.sort_by(&:first)]
      end

      private

      def capture_variables(line)
        line.scan(/ENV(?:\[|\.fetch\()['"]([^'"]+)['"]/).flatten
      end
    end
  end
end
