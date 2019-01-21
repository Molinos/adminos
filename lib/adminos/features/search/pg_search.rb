module Adminos
  module Search
    module PgSearch
      extend ActiveSupport::Concern

      included do
        def self.setup_search(*args)
          include ::PgSearch

          pg_search_scope :base_search, against: search_fields, associated_against: associated_fields
        end
      end

      class_methods do
        def search_fields
          base_search_fields + against
        end

        def associated_fields
          associated_against.merge(actiontext_attributes)
        end

        def associated_against
          {}
        end

        def against
          []
        end

        def actiontext_attributes
          reflect_has_one = self.reflect_on_all_associations(:has_one)
          rich_text_attributes = reflect_has_one.map(&:name).map { |name| name if name.to_s.include?('rich_text_') }.compact

          rich_text_attributes.inject({}) do |memo, attr|
            memo[attr] = [attr.to_s.gsub('rich_text_', '')]
            memo
          end
        end

        def base_search_fields
          self.columns.map { |c| c.name if [:string, :text].include?(c.type) }.compact
        end
      end
    end
  end
end
